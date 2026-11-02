import 'package:flutter/material.dart';

class CrewingScreen extends StatelessWidget {
  const CrewingScreen({super.key});

  static const List<Map<String, String>> _agencies = [
    {
      'name': 'Marlow Navigation',
      'location': 'Лимассол / Одесса',
      'rating': '4.9',
      'reviews': '128 отзывов',
    },
    {
      'name': 'Columbia Shipmanagement',
      'location': 'Гамбург / Клайпеда',
      'rating': '4.7',
      'reviews': '94 отзыва',
    },
    {
      'name': 'V.Ships',
      'location': 'Монако / Рига',
      'rating': '4.5',
      'reviews': '210 отзывов',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        title: const Text(
          'Крюинговые агентства',
          style: TextStyle(
            color: Color(0xFF00FF87),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1C2541),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _agencies.length,
          itemBuilder: (context, index) {
            final agency = _agencies[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2541),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.25)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF87).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.business,
                      color: Color(0xFF00FF87),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agency['name'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '📍 ${agency['location']}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '💬 ${agency['reviews']}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        agency['rating'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
