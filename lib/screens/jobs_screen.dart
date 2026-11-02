import 'package:flutter/material.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вакансии FleetWatch', style: TextStyle(color: Color(0xFF00FF87))),
        backgroundColor: const Color(0xFF1C2541),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Color(0xFF00FF87)),
            onPressed: () {
              // PRO Монетизация: Подписка
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('FleetWatch PRO активирован: Доступ к горячим вакансиям!')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildJobCard(
            context,
            title: 'Chief Engineer (Старший механик)',
            salary: '\$8,500 / mo',
            vessel: 'Container Ship (5000 TEU)',
            company: 'Marlow Navigation',
          ),
          const SizedBox(height: 12),
          _buildJobCard(
            context,
            title: 'Second Officer (2-й помощник)',
            salary: '\$4,200 / mo',
            vessel: 'Oil Tanker (110,000 DWT)',
            company: 'Columbia Shipmanagement',
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, {required String title, required String salary, required String vessel, required String company}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2541).withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF87).withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              Text(salary, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF00FF87))),
            ],
          ),
          const SizedBox(height: 8),
          Text(vessel, style: const TextStyle(color: Colors.white7Names ?? Colors.white70, fontSize: 13)),
          Text('Крюинг: $company', style: const TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF87),
                foregroundColor: const Color(0xFF0B132B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Действие при отклике
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Отклик отправлен в крюинг!')),
                );
              },
              child: const Text('Откликнуться в 1 клик', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
