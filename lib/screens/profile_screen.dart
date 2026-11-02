import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        title: const Text(
          'Профиль & PRO',
          style: TextStyle(
            color: Color(0xFF00FF87),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1C2541),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2541),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 31,
                    backgroundColor: Color(0xFF00FF87),
                    child: Icon(Icons.person, size: 34, color: Color(0xFF0B132B)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Капитан Александр',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Master / Captain (FG)',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '🟢 Готов к выходу в рейс',
                          style: TextStyle(
                            color: Color(0xFF00FF87),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Морской PRO-функционал',
              style: TextStyle(
                color: Color(0xFF00F2FE),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureTile(
              context,
              icon: Icons.picture_as_pdf,
              title: 'Генератор CV в PDF',
              subtitle: 'Создать международное резюме за 1 клик.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PDF-резюме успешно создано.')),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildFeatureTile(
              context,
              icon: Icons.notifications_active,
              title: 'Трекер документов и дипломов',
              subtitle: 'Напоминания о STCW, медкомиссии и сертификатах.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Все сертификаты актуальны.')),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildFeatureTile(
              context,
              icon: Icons.rocket_launch,
              title: 'Авторассылка в 50+ крюингов',
              subtitle: 'Приоритетная рассылка анкеты для PRO-пользователей.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Анкета отправлена в крюинговые компании.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFeatureTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2541).withOpacity(0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00FF87), size: 28),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
        onTap: onTap,
      ),
    );
  }
}
