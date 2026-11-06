import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../features/auth/auth_provider.dart';
import '../features/auth/user_model.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> job;
  const JobDetailScreen({super.key, required this.job});

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen> {
  final _msgC = TextEditingController();
  bool _sending = false;

  Future<void> _apply() async {
    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn || auth.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Войдите, чтобы откликнуться')),
      );
      return;
    }
    if (auth.user?.role != UserRole.seaman) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Откликаться могут только моряки')),
      );
      return;
    }
    setState(() => _sending = true);
    try {
      final res = await http
          .post(
            Uri.parse('$apiBase/api/apply'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${auth.token}',
            },
            body: jsonEncode({
              'job': widget.job['id'],
              'message': _msgC.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 30));
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Отклик отправлен')),
          );
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['error']?.toString() ?? 'Ошибка')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка сети')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final j = widget.job;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Вакансия', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            j['title']?.toString() ?? 'Вакансия',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            j['agency']?.toString() ?? '',
            style: const TextStyle(color: Color(0xFF1D9BF0), fontSize: 15),
          ),
          const SizedBox(height: 16),
          _row('Должность', j['rank']),
          _row('Тип судна', j['ship_type']),
          _row('Зарплата', j['salary']),
          _row('Контакт', j['contact']),
          const SizedBox(height: 12),
          const Text('Описание', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            j['descr']?.toString() ?? 'Нет описания',
            style: const TextStyle(color: Colors.white, height: 1.4),
          ),
          const SizedBox(height: 24),
          const Text('Сообщение (необязательно)', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          TextField(
            controller: _msgC,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Коротко о себе',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF16181C),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D9BF0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: _sending ? null : _apply,
            child: _sending
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Откликнуться'),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, dynamic value) {
    final v = value?.toString() ?? '';
    if (v.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(color: Colors.white54))),
          Expanded(child: Text(v, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
