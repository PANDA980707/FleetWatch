import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../features/auth/auth_provider.dart';
import '../features/auth/user_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  List<Map<String, dynamic>> _list = [];
  bool _loadingList = false;

  Future<void> _loadList() async {
    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn || auth.token == null) return;
    setState(() => _loadingList = true);
    try {
      final isAgency = auth.user?.role == UserRole.crewing;
      final path = isAgency ? '/api/my/applicants' : '/api/my/applications';
      final res = await http
          .get(
            Uri.parse('$apiBase$path'),
            headers: {'Authorization': 'Bearer ${auth.token}'},
          )
          .timeout(const Duration(seconds: 30));
      final data = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode == 200 && data is List) {
        setState(() {
          _list = data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          _loadingList = false;
        });
      } else {
        setState(() {
          _list = [];
          _loadingList = false;
        });
      }
    } catch (_) {
      setState(() {
        _list = [];
        _loadingList = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadList());
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final isAgency = user?.role == UserRole.crewing;

    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        title: Text(
          isAgency ? 'Профиль крюинга' : 'Профиль & PRO',
          style: const TextStyle(color: Color(0xFF00FF87), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1C2541),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF00FF87)),
            onPressed: _loadList,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF00FF87)),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2541),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 31,
                    backgroundColor: const Color(0xFF00FF87),
                    child: Icon(
                      isAgency ? Icons.business : Icons.person,
                      size: 34,
                      color: const Color(0xFF0B132B),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Гость',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(user?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 8),
                        Text(
                          isAgency ? '🏢 Крюинговая компания' : '🌊 Моряк',
                          style: const TextStyle(color: Color(0xFF00FF87), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              isAgency ? 'Отклики на ваши вакансии' : 'Мои отклики',
              style: const TextStyle(color: Color(0xFF00F2FE), fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_loadingList)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator(color: Color(0xFF00FF87))),
              )
            else if (_list.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Пока пусто.\nМоряк откликается на вакансию — заявка появится здесь у крюинга.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54),
                ),
              )
            else
              ..._list.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2541),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']?.toString() ?? 'Вакансия',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      if (isAgency) ...[
                        const SizedBox(height: 4),
                        Text('${item['name'] ?? ''} · ${item['email'] ?? ''}',
                            style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        if ((item['message'] ?? '').toString().isNotEmpty)
                          Text(item['message'].toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      ] else ...[
                        const SizedBox(height: 4),
                        Text('Статус: ${item['status'] ?? 'new'}',
                            style: const TextStyle(color: Color(0xFF00FF87), fontSize: 13)),
                      ],
                    ],
                  ),
                );
              }),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => ref.read(authProvider.notifier).logout(),
              icon: const Icon(Icons.logout),
              label: const Text('Выйти из аккаунта'),
            ),
          ],
        ),
      ),
    );
  }
}
