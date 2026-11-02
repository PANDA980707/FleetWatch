import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  static const List<Map<String, String>> _jobs = [
    {
      'title': 'Chief Engineer',
      'salary': '\$8,500 / mo',
      'vessel': 'Container Ship • 5,000 TEU',
      'company': 'Marlow Navigation',
      'status': 'Горячая вакансия',
    },
    {
      'title': 'Second Officer',
      'salary': '\$4,200 / mo',
      'vessel': 'Oil Tanker • 110,000 DWT',
      'company': 'Columbia Shipmanagement',
      'status': 'Открыто',
    },
    {
      'title': 'Bosun',
      'salary': '\$3,800 / mo',
      'vessel': 'Bulk Carrier',
      'company': 'Aegean Shipping',
      'status': 'Новый',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('Вакансии FleetWatch'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF183C4C), Color(0xFF0D2135)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Найдите подходящее судно',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Подборка актуальных вакансий для моряков и офицерского состава',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: const [
                      _MiniStat(label: 'Новых', value: '24'),
                      SizedBox(width: 12),
                      _MiniStat(label: 'Горячих', value: '08'),
                      SizedBox(width: 12),
                      _MiniStat(label: 'PRO', value: 'YES'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Самые актуальные',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._jobs.map((job) => _JobCard(job: job)).toList(),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.panelAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final Map<String, String> job;

  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final status = job['status'] ?? '';
    final isHot = status.contains('Горяч');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  job['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                job['salary'] ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.emerald,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            job['vessel'] ?? '',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            'Крюинг: ${job['company'] ?? ''}',
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isHot ? AppColors.emerald.withOpacity(0.12) : AppColors.panelAlt,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isHot ? AppColors.emerald : AppColors.border,
              ),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: isHot ? AppColors.emerald : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emerald,
                foregroundColor: AppColors.navy,
              ),
              child: const Text('Откликнуться в 1 клик'),
            ),
          ),
        ],
      ),
    );
  }
}
