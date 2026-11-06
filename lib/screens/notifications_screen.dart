import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushEnabled = true;
  bool _urgentAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Matching & Уведомления', style: TextStyle(color: Color(0xFF1D9BF0))),
        backgroundColor: const Color(0xFF16181C),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF16181C).withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1D9BF0).withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '⚡ Автоподбор вакансий (Smart Matching)',
                  style: TextStyle(color: Color(0xFF1D9BF0), fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Алгоритм анализирует ваш профиль, дипломы и стаж, отправляя пуш-уведомления за 30 минут до публикации вакансии в общем доступе (PRO функция).',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Включить пуш-уведомления', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Получать алерты о новых рейсах', style: TextStyle(color: Colors.white54, fontSize: 12)),
            value: _pushEnabled,
            activeColor: const Color(0xFF1D9BF0),
            onChanged: (bool value) {
              setState(() {
                _pushEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Срочные горячие контракты', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Вакансии с заменой "на вчера" и повышенной ставкой', style: TextStyle(color: Colors.white54, fontSize: 12)),
            value: _urgentAlerts,
            activeColor: const Color(0xFF1D9BF0),
            onChanged: (bool value) {
              setState(() {
                _urgentAlerts = value;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D9BF0),
              foregroundColor: const Color(0xFF000000),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Настройки фильтров Smart Matching сохранены!')),
              );
            },
            child: const Text('Сохранить параметры поиска', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
