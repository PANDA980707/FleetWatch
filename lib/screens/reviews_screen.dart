import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final List<Map<String, String>> _reviews = [
    {
      'vessel': 'M/V Pacific Leader',
      'company': 'Marlow Navigation',
      'rating': '4.8',
      'comment': 'Зарплата вовремя, питание отличное, интернет Starlink безлимитный для экипажа.',
      'author': 'Анонимный Стармех',
    },
    {
      'vessel': 'MT Atlantic Glory',
      'company': 'V.Ships',
      'rating': '4.2',
      'comment': 'Судно старое, но машины надежные. Смены вовремя по контракту.',
      'author': 'Анонимный 2-й помощник',
    },
  ];

  final TextEditingController _vesselController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  void _addReview() {
    if (_vesselController.text.trim().isEmpty || _commentController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _reviews.insert(0, {
        'vessel': _vesselController.text.trim(),
        'company': 'Крюинг / Судовладелец',
        'rating': '5.0',
        'comment': _commentController.text.trim(),
        'author': 'Моряк FleetWatch',
      });
    });

    _vesselController.clear();
    _commentController.clear();
    Navigator.of(context).pop();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.panel,
        title: const Text('Добавить отзыв о судне'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _vesselController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Название судна и тип',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _commentController,
                minLines: 3,
                maxLines: 5,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Условия, зарплата, питание...',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: _addReview,
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('Отзывы о судах'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: const [
                  Icon(Icons.star_rounded, color: AppColors.amber, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Средний рейтинг: 4.5',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Новые отзывы',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ..._reviews.map((review) => _ReviewCard(review: review)).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        backgroundColor: AppColors.emerald,
        child: const Icon(Icons.add, color: AppColors.navy),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, String> review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review['vessel'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    review['rating'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Крюинг: ${review['company']}',
            style: const TextStyle(color: AppColors.cyan, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            review['comment'] ?? '',
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Text(
            '✍️ ${review['author']}',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
