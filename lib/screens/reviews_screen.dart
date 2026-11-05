import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../features/auth/auth_provider.dart';

class ReviewsScreen extends ConsumerStatefulWidget {
  const ReviewsScreen({super.key});

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  final _mmsiC = TextEditingController();
  final _shipC = TextEditingController();
  final _textC = TextEditingController();
  int _rating = 5;

  List<Map<String, dynamic>> _items = [];
  double _avg = 0;
  int _count = 0;
  bool _loading = false;
  String? _error;
  String? _currentMmsi;

  Future<void> _load(String mmsi) async {
    final id = mmsi.trim();
    if (id.isEmpty) {
      _toast('Введите MMSI судна');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _currentMmsi = id;
    });
    try {
      final res = await http
          .get(Uri.parse('$apiBase/api/reviews?mmsi=$id'))
          .timeout(const Duration(seconds: 30));
      final data = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode != 200) {
        throw Exception(data['error'] ?? 'Ошибка загрузки');
      }
      final list = (data['items'] as List? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      setState(() {
        _items = list;
        _avg = (data['avg'] as num?)?.toDouble() ?? 0;
        _count = data['count'] as int? ?? list.length;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _submit() async {
    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn || auth.token == null) {
      _toast('Войдите, чтобы оставить отзыв');
      return;
    }
    final mmsi = int.tryParse((_currentMmsi ?? _mmsiC.text).trim());
    final text = _textC.text.trim();
    if (mmsi == null) {
      _toast('Сначала найдите судно по MMSI');
      return;
    }
    if (text.length < 10) {
      _toast('Текст отзыва — минимум 10 символов');
      return;
    }
    try {
      final res = await http
          .post(
            Uri.parse('$apiBase/api/reviews'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${auth.token}',
            },
            body: jsonEncode({
              'mmsi': mmsi,
              'ship': _shipC.text.trim(),
              'rating': _rating,
              'text': text,
            }),
          )
          .timeout(const Duration(seconds: 30));
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (mounted) Navigator.pop(context);
        _textC.clear();
        _toast('Отзыв сохранён');
        _load(mmsi.toString());
      } else {
        _toast(body['error']?.toString() ?? 'Не удалось отправить');
      }
    } catch (e) {
      _toast('Ошибка сети');
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1C2541),
              title: const Text('Отзыв о судне', style: TextStyle(color: Color(0xFF00FF87))),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _shipC,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Название судна',
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(5, (i) {
                        final v = i + 1;
                        return IconButton(
                          onPressed: () => setLocal(() => _rating = v),
                          icon: Icon(
                            v <= _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                        );
                      }),
                    ),
                    TextField(
                      controller: _textC,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Условия, питание, зарплата... (от 10 символов)',
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF87),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _submit,
                  child: const Text('Отправить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        title: const Text(
          'Отзывы о судах',
          style: TextStyle(color: Color(0xFF00FF87), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1C2541),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00FF87),
        onPressed: _showAddDialog,
        child: const Icon(Icons.add, color: Color(0xFF0B132B)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mmsiC,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'MMSI судна',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: const Color(0xFF1C2541),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FF87),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    ),
                    onPressed: () => _load(_mmsiC.text),
                    child: const Text('Найти'),
                  ),
                ],
              ),
            ),
            if (_currentMmsi != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('MMSI $_currentMmsi', style: const TextStyle(color: Colors.white70)),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      _count == 0 ? 'нет оценок' : '${_avg.toStringAsFixed(1)} ($_count)',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF00FF87)))
                  : _error != null
                      ? Center(child: Text(_error!, style: const TextStyle(color: Colors.white70)))
                      : _items.isEmpty
                          ? const Center(
                              child: Text(
                                'Введите MMSI и нажмите «Найти».\nИли оставьте первый отзыв.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white54),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _items.length,
                              itemBuilder: (context, index) {
                                final r = _items[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C2541),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.25)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              r['name']?.toString() ?? 'Моряк',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${r['rating'] ?? ''}',
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        r['text']?.toString() ?? '',
                                        style: const TextStyle(color: Colors.white70, height: 1.4),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
