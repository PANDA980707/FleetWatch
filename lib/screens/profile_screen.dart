import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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
  String? _avatar;
  final _rankC = TextEditingController();
  final _expC = TextEditingController();
  final _vesselC = TextEditingController();
  final _natC = TextEditingController();
  final _phoneC = TextEditingController();

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

  Future<void> _saveProfile() async {
    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn || auth.token == null) return;
    try {
      final res = await http.post(
        Uri.parse('$apiBase/api/me/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.token}',
        },
        body: jsonEncode({
          'rank': _rankC.text.trim(),
          'experience': _expC.text.trim(),
          'vessel_type': _vesselC.text.trim(),
          'nationality': _natC.text.trim(),
          'phone': _phoneC.text.trim(),
        }),
      ).timeout(const Duration(seconds: 30));
      if (res.statusCode == 200 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Анкета сохранена')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось сохранить')),
        );
      }
    }
  }

  Future<void> _pickAvatar() async {
    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn || auth.token == null) return;
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 70);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final b64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
    try {
      final res = await http
          .post(
            Uri.parse('$apiBase/api/me/avatar'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${auth.token}',
            },
            body: jsonEncode({'avatar': b64}),
          )
          .timeout(const Duration(seconds: 30));
      if (res.statusCode == 200) {
        setState(() => _avatar = b64);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Фото обновлено')),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось загрузить фото')),
        );
      }
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          isAgency ? 'Профиль крюинга' : 'Профиль',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF1D9BF0)),
            onPressed: _loadList,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF1D9BF0)),
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
                color: const Color(0xFF16181C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: const Color(0xFF1D9BF0),
                      backgroundImage: _avatar != null
                          ? MemoryImage(base64Decode(_avatar!.split(',').last))
                          : null,
                      child: _avatar == null
                          ? Icon(
                              isAgency ? Icons.business : Icons.person,
                              size: 32,
                              color: Colors.white,
                            )
                          : null,
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
                        const SizedBox(height: 6),
                        Text(
                          isAgency ? 'Крюинговая компания' : 'Моряк',
                          style: const TextStyle(color: Color(0xFF1D9BF0), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (!isAgency) ...[
              const Text('Анкета', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _field(_rankC, 'Должность'),
              _field(_expC, 'Опыт (лет / рейсы)'),
              _field(_vesselC, 'Тип судна'),
              _field(_natC, 'Гражданство'),
              _field(_phoneC, 'Телефон'),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9BF0),
                  foregroundColor: Colors.white,
                ),
                onPressed: _saveProfile,
                child: const Text('Сохранить анкету'),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              isAgency ? 'Отклики на ваши вакансии' : 'Мои отклики',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_loadingList)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator(color: Color(0xFF1D9BF0))),
              )
            else if (_list.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Пока пусто',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54),
                ),
              )
            else
              ..._list.map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16181C),
                      borderRadius: BorderRadius.circular(12),
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
                        ] else ...[
                          const SizedBox(height: 4),
                          Text('Статус: ${item['status'] ?? 'new'}',
                              style: const TextStyle(color: Color(0xFF1D9BF0), fontSize: 13)),
                        ],
                      ],
                    ),
                  )),
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
  Widget _field(TextEditingController c, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: c,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: const Color(0xFF16181C),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
  }
}
