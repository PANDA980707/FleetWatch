import 'package:flutter/material.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  static const List<Map<String, String>> _jobs = [
    {
      'title': 'Chief Engineer',
      'salary': '\$8,500 / mo',
      'vessel': 'Container Ship (5000 TEU)',
      'company': 'Marlow Navigation',
      'status': 'Горячая вакансия',
    },
    {
      'title': 'Second Officer',
      'salary': '\$4,200 / mo',
      'vessel': 'Oil Tanker (110,000 DWT)',
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
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        title: const Text(
          'Вакансии FleetWatch',
          style: TextStyle(
            color: Color(0xFF00FF87),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1C2541),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Color(0xFF00FF87)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('FleetWatch PRO активирован: доступ к горячим вакансиям.'),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
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
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF87).withOpacity(0.08),
                    spreadRadius: 1,
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          job['title'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        job['salary'] ?? '',
                        style: const TextStyle(
                          color: Color(0xFF00FF87),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    job['vessel'] ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Крюинг: ${job['company'] ?? ''}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF112D25),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFF00FF87)),
                    ),
                    child: Text(
                      job['status'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF00FF87),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF87),
                        foregroundColor: const Color(0xFF0B132B),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Отклик отправлен на вакансию: ${job['title']}'),
                          ),
                        );
                      },
                      child: const Text(
                        'Откликнуться в 1 клик',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
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
