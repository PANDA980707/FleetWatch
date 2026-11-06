import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../features/auth/auth_provider.dart';
import '../features/auth/user_model.dart';

class CrewingScreen extends ConsumerStatefulWidget {
  const CrewingScreen({super.key});

  @override
  ConsumerState<CrewingScreen> createState() => _CrewingScreenState();
}

class _CrewingScreenState extends ConsumerState<CrewingScreen> {
  List<Map<String, dynamic>> _agencies = [];
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
          .get(Uri.parse('$apiBase/api/agencies'))
          .timeout(const Duration(seconds: 30));
      final data = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode != 200) {
        throw Exception(data is Map ? (data['error'] ?? 'Ошибка') : 'Ошибка');
      }
      final list = (data as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      setState(() {
        _agencies = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _showReviews(Map<String, dynamic> agency) async {
    final id = agency['id'];
    final name = agency['name']?.toString() ?? 'Крюинг';
    try {
      final res = await http
          .get(Uri.parse('$apiBase/api/agency/reviews?agency=$id'))
          .timeout(const Duration(seconds: 30));
      final data = jsonDecode(utf8.decode(res.bodyBytes));
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF1C2541),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) => _ReviewsSheet(
          agencyId: id,
          agencyName: name,
          avg: (data['avg'] as num?)?.toDouble() ?? 0,
          count: data['count'] as int? ?? 0,
          items: (data['items'] as List? ?? [])
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось загрузить отзывы')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        title: const Text(
          'Крюинговые агентства',
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
              : _agencies.isEmpty
                  ? const Center(
                      child: Text(
                        'Пока нет зарегистрированных крюингов.',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : RefreshIndicator(
                      color: const Color(0xFF00FF87),
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _agencies.length,
                        itemBuilder: (context, index) {
                          final a = _agencies[index];
                          return GestureDetector(
                            onTap: () => _showReviews(a),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C2541),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.25)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00FF87).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.business, color: Color(0xFF00FF87), size: 28),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          a['name']?.toString() ?? 'Крюинг',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          a['email']?.toString() ?? '',
                                          style: const TextStyle(color: Colors.white54, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: Colors.white38),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

class _ReviewsSheet extends ConsumerStatefulWidget {
  final dynamic agencyId;
  final String agencyName;
  final double avg;
  final int count;
  final List<Map<String, dynamic>> items;

  const _ReviewsSheet({
    required this.agencyId,
    required this.agencyName,
    required this.avg,
    required this.count,
    required this.items,
  });

  @override
  ConsumerState<_ReviewsSheet> createState() => _ReviewsSheetState();
}

class _ReviewsSheetState extends ConsumerState<_ReviewsSheet> {
  final _textC = TextEditingController();
  int _rating = 5;
  late List<Map<String, dynamic>> _items;
  late double _avg;
  late int _count;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
    _avg = widget.avg;
    _count = widget.count;
  }

  Future<void> _submit() async {
    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn || auth.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Войдите как моряк, чтобы оставить отзыв')),
      );
      return;
    }
    if (auth.user?.role != UserRole.seaman) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Отзывы могут оставлять только моряки')),
      );
      return;
    }
    final text = _textC.text.trim();
    if (text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Текст от 10 символов')),
      );
      return;
    }
    try {
      final res = await http
          .post(
            Uri.parse('$apiBase/api/agency/reviews'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${auth.token}',
            },
            body: jsonEncode({
              'agency': widget.agencyId,
              'rating': _rating,
              'text': text,
            }),
          )
          .timeout(const Duration(seconds: 30));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Отзыв сохранён')),
        );
      } else {
        final body = jsonDecode(utf8.decode(res.bodyBytes));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['error']?.toString() ?? 'Ошибка')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка сети')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              widget.agencyName,
              style: const TextStyle(color: Color(0xFF00FF87), fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  _count == 0 ? 'нет оценок' : '${_avg.toStringAsFixed(1)} ($_count)',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Оставить отзыв', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                final v = i + 1;
                return IconButton(
                  onPressed: () => setState(() => _rating = v),
                  icon: Icon(v <= _rating ? Icons.star : Icons.star_border, color: Colors.amber),
                );
              }),
            ),
            TextField(
              controller: _textC,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Ваш отзыв (от 10 символов)',
                hintStyle: TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Color(0xFF0B132B),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF87),
                foregroundColor: Colors.black,
              ),
              onPressed: _submit,
              child: const Text('Отправить'),
            ),
            const SizedBox(height: 20),
            const Text('Отзывы', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_items.isEmpty)
              const Text('Пока нет отзывов', style: TextStyle(color: Colors.white54))
            else
              ..._items.map((r) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B132B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(r['name']?.toString() ?? 'Моряк',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                Text('${r['rating']}', style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(r['text']?.toString() ?? '', style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  )),
          ],
        );
      },
    );
  }
}
