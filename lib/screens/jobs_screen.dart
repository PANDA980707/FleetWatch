import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../features/auth/auth_provider.dart';
import '../features/auth/user_model.dart';

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
      _toast('Войдите в аккаунт, чтобы откликнуться');
      return;
    }
    if (auth.user?.role != UserRole.seaman) {
      _toast('Откликаться могут только моряки');
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
        _toast('Отклик отправлен: ${job['title']}');
      } else {
        _toast(body['error']?.toString() ?? 'Не удалось отправить отклик');
      }
    } catch (e) {
      _toast('Ошибка сети');
    }
  }

  Future<void> _publishJob() async {
    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn || auth.token == null) {
      _toast('Войдите как крюинг');
      return;
    }
    if (auth.user?.role != UserRole.crewing) {
      _toast('Публиковать могут только крюинговые компании');
      return;
    }

    final titleC = TextEditingController();
    final rankC = TextEditingController();
    final shipC = TextEditingController();
    final salaryC = TextEditingController();
    final contactC = TextEditingController();
    final descrC = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C2541),
        title: const Text('Новая вакансия', style: TextStyle(color: Color(0xFF00FF87))),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(titleC, 'Название *'),
              _field(rankC, 'Должность / rank'),
              _field(shipC, 'Тип судна'),
              _field(salaryC, 'Зарплата'),
              _field(contactC, 'Контакт *'),
              _field(descrC, 'Описание * (от 20 символов)', maxLines: 4),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF87),
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Опубликовать'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      final res = await http
          .post(
            Uri.parse('$apiBase/api/jobs'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${auth.token}',
            },
            body: jsonEncode({
              'title': titleC.text.trim(),
              'rank': rankC.text.trim(),
              'shipType': shipC.text.trim(),
              'salary': salaryC.text.trim(),
              'contact': contactC.text.trim(),
              'description': descrC.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 30));
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        _toast('Вакансия отправлена на модерацию');
        _load();
      } else {
        _toast(body['error']?.toString() ?? 'Не удалось опубликовать');
      }
    } catch (e) {
      _toast('Ошибка сети');
    }
  }

  Widget _field(TextEditingController c, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: const Color(0xFF0B132B),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isAgency = auth.user?.role == UserRole.crewing;

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
      floatingActionButton: isAgency
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF00FF87),
              foregroundColor: Colors.black,
              icon: const Icon(Icons.add),
              label: const Text('Опубликовать'),
              onPressed: _publishJob,
            )
          : null,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00FF87)))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
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
                )
              : _jobs.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          isAgency
                              ? 'Пока нет одобренных вакансий.\nНажмите «Опубликовать» — после модерации они появятся здесь.'
                              : 'Пока нет одобренных вакансий.\nЗагляните позже.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white54),
                        ),
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
