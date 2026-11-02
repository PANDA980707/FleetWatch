import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль & PRO', style: TextStyle(color: Color(0xFF00FF87))),
        backgroundColor: const Color(0xFF1C2541),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Статус моряка
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2541),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFF00FF87),
                  child: Icon(Icons.person, size: 35, color: Color(0xFF0B132B)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Капитан Александр', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 4),
                      Text('Master / Captain (FG)', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      SizedBox(height: 6),
                      Text('🟢 Готов к выходу в рейс', style: TextStyle(color: Color(0xFF00FF87), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Блок монетизации: PRO Функции
          const Text('Морской PRO-функционал', style: TextStyle(color: Color(0xFF00F2FE), fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
          _buildFeatureTile(
            icon: Icons.picture_as_pdf,
            title: 'Генератор CV в PDF',
            subtitle: 'Создать международный формат резюме за 1 клик',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF-резюме успешно сгенерировано и сохранено!')),
              );
            },
          ),
          const SizedBox(height: 10),
          _buildFeatureTile(
            icon: Icons.notifications_active,
            title: 'Трекер документов и дипломов',
            subtitle: 'Напоминания об окончании STCW и медкомиссии',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Все сертификаты актуальны. До истечения > 6 месяцев.')),
              );
            },
          ),
          const SizedBox(height: 10),
          _buildFeatureTile(
            icon: Icons.rocket_launch,
            title: 'Авторассылка в 50+ крюингов',
            subtitle: 'Приоритетная рассылка вашей анкеты (PRO)',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Анкета отправлена в топовые крюинговые компании!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2541).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00FF87), size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
        onTap: onTap,
      ),
    );
  }
}
