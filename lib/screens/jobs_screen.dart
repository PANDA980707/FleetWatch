import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../features/auth/auth_provider.dart';

class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  List<Map<String, dynamic>> _jobs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await http
          .get(Uri.parse('$apiBase/api/jobs'))
          .timeout(const Duration(seconds: 30));
      if (res.statusCode != 200) {
        throw Exception('Ошибка сервера (${res.statusCode})');
      }
      final data = jsonDecode(utf8.decode(res.bodyBytes));
      final list = (data as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      setState(() {
        _jobs = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _apply(Map<String, dynamic> job) async {
    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn || auth.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Войдите в аккаунт, чтобы откликнуться')),
      );
      return;
    }
    if (auth.user?.role.name != 'seaman') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Откликаться могут только моряки')),
      );
      return;
    }
    try {
      final res = await http
          .post(
            Uri.parse('$apiBase/api/apply'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${auth.token}',
            },
            body: jsonEncode({
              'job': job['id'],
              'message': 'Интересует вакансия ${job['title']}',
            }),
          )
          .timeout(const Duration(seconds: 30));
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Отклик отправлен: ${job['title']}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['error'] ?? 'Не удалось отправить отклик')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сети: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        title: const Text(
          'Вакансии FleetWatch',
          style: TextStyle(color: Color(0xFF00FF87), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1C2541),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF00FF87)),
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00FF87)))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _load,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00FF87),
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                )
              : _jobs.isEmpty
                  ? const Center(
                      child: Text(
                        'Пока нет одобренных вакансий.\nКрюинг может опубликовать — после модерации они появятся здесь.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : RefreshIndicator(
                      color: const Color(0xFF00FF87),
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _jobs.length,
                        itemBuilder: (context, index) {
                          final job = _jobs[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C2541),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.25)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        job['title']?.toString() ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      job['salary']?.toString() ?? '',
                                      style: const TextStyle(
                                        color: Color(0xFF00FF87),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if ((job['rank'] ?? '').toString().isNotEmpty)
                                  Text('Должность: ${job['rank']}', style: const TextStyle(color: Colors.white70)),
                                if ((job['ship_type'] ?? '').toString().isNotEmpty)
                                  Text('Судно: ${job['ship_type']}', style: const TextStyle(color: Colors.white70)),
                                Text('Крюинг: ${job['agency'] ?? ''}', style: const TextStyle(color: Colors.white54)),
                                if ((job['descr'] ?? '').toString().isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(job['descr'].toString(), style: const TextStyle(color: Colors.white60, fontSize: 13)),
                                ],
                                const SizedBox(height: 14),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00FF87),
                                      foregroundColor: const Color(0xFF0B132B),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed: () => _apply(job),
                                    child: const Text('Откликнуться', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
