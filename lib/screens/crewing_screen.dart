import 'package:flutter/material.dart';

class CrewingScreen extends StatelessWidget {
  const CrewingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Крюинговые Агентства', style: TextStyle(color: Color(0xFF00FF87))),
        backgroundColor: const Color(0xFF1C2541),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCrewingCard(
            context,
            name: 'Marlow Navigation',
            location: 'Лимассол / Одесса',
            rating: '4.9',
            reviews: '128 отзывов',
          ),
          const SizedBox(height: 12),
          _buildCrewingCard(
            context,
            name: 'Columbia Shipmanagement',
            location: 'Гамбург / Клайпеда',
            rating: '4.7',
            reviews: '94 отзыва',
          ),
          const SizedBox(height: 12),
          _buildCrewingCard(
            context,
            name: 'V.Ships',
            location: 'Монако / Рига',
            rating: '4.5',
            reviews: '210 отзывов',
          ),
        ],
      ),
    );
  }

  Widget _buildCrewingCard(BuildContext context, {required String name, required String location, required String rating, required String reviews}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2541).withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00FF87).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.business, color: Color(0xFF00FF87), size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text('📍 $location', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text('💬 Отзывов: $reviews', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(rating, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
