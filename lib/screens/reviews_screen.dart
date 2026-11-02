import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final List> _reviews = [
    {
      'vessel': 'M/V Pacific Leader (Container)',
      'company': 'Marlow Navigation',
      'rating': '4.8',
      'comment': 'Зарплата вовремя, питание отличное, интернет Starlink безлимитный для экипажа!',
      'author': 'Анонимный Стармех',
    },
    {
      'vessel': 'MT Atlantic Glory (Tanker)',
      'company': 'V.Ships',
      'rating': '4.2',
      'comment': 'Судно старое, но машины надежные. Смены вовремя по контракту.',
      'author': 'Анонимный 2-й помощник',
    },
  ];

  final TextEditingController _vesselController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  void _addNewReview() {
    if (_vesselController.text.isNotEmpty && _commentController.text.isNotEmpty) {
      setState(() {
        _reviews.insert(0, {
          'vessel': _vesselController.text,
          'company': 'Крюинг/Судовладелец',
          'rating': '5.0',
          'comment': _commentController.text,
          'author': 'Моряк FleetWatch',
        });
      });
      _vesselController.clear();
      _commentController.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Отзыв успешно добавлен в базу!')),
      );
    }
  }

  void _showAddReviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C2541),
          title: const Text('Добавить отзыв о судне', style: TextStyle(color: Color(0xFF00FF87))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _vesselController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Название судна и тип',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00FF87))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _commentController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Условия, зарплата, питание...',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00FF87))),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Отмена', style: TextStyle(color: Colors.white54)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF87)),
              onPressed: _addNewReview,
              child: const Text('Отправить', style: TextStyle(color: Color(0xFF0B132B), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отзывы о судах и экипажах', style: TextStyle(color: Color(0xFF00FF87))),
        backgroundColor: const Color(0xFF1C2541),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _reviews.length,
        itemBuilder: (context, index) {
          final review = _reviews[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2541).withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(review['vessel']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(review['rating']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Крюинг: ${review['company']}', style: const TextStyle(color: Color(0xFF00F2FE), fontSize: 13)),
                const SizedBox(height: 8),
                Text(review['comment']!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 10),
                Text('✍️ ${review['author']}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00FF87),
        child: const Icon(Icons.add, color: Color(0xFF0B132B)),
        onPressed: _showAddReviewDialog,
      ),
    );
  }
}
