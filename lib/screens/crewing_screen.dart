import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CrewingScreen extends StatelessWidget {
  const CrewingScreen({super.key});

  static const List<Map<String, String>> _agencies = [
    {
      'name': 'Marlow Navigation',
      'location': 'Лимассол / Одесса',
      'rating': '4.9',
      'reviews': '128 отзывов',
      'fleet': 'Container / Tanker',
    },
    {
      'name': 'Columbia Shipmanagement',
      'location': 'Гамбург / Клайпеда',
      'rating': '4.7',
      'reviews': '94 отзыва',
      'fleet': 'Bulk / LPG',
    },
    {
      'name': 'V.Ships',
      'location': 'Монако / Рига',
      'rating': '4.5',
      'reviews': '210 отзывов',
      'fleet': 'Tanker / Offshore',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('Крюинговые агентства'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search_rounded, color: AppColors.emerald),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Поиск по крюингам и портам',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Рекомендованные',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ..._agencies.map((agency) => _AgencyCard(agency: agency)).toList(),
          ],
        ),
      ),
    );
  }
}

class _AgencyCard extends StatelessWidget {
  final Map<String, String> agency;

  const _AgencyCard({required this.agency});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.emerald.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.business_rounded, color: AppColors.emerald, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agency['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '📍 ${agency['location']}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  '🚢 ${agency['fleet']}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      agency['rating'] ?? '',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      agency['reviews'] ?? '',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
