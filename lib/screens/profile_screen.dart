import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/auth_provider.dart';
import '../features/auth/user_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final isAgency = user?.role == UserRole.crewing;

    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        title: Text(
          isAgency ? 'Профиль крюинга' : 'Профиль & PRO',
          style: const TextStyle(
            color: Color(0xFF00FF87),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1C2541),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF00FF87)),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
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
                  CircleAvatar(
                    radius: 31,
                    backgroundColor: const Color(0xFF00FF87),
                    child: Icon(
                      isAgency ? Icons.business : Icons.person,
                      size: 34,
                      color: const Color(0xFF0B132B),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Гость',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isAgency ? '🏢 Крюинговая компания' : '🌊 Моряк',
                          style: const TextStyle(
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
            Text(
              isAgency ? 'Инструменты крюинга' : 'Морской PRO-функционал',
              style: const TextStyle(
                color: Color(0xFF00F2FE),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (isAgency) ...[
              _tile(
                context,
                icon: Icons.work_outline,
                title: 'Мои вакансии',
                subtitle: 'Публикация и статус объявлений (на модерации / одобрено).',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Список вакансий — во вкладке «Вакансии» → Опубликовать')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _tile(
                context,
                icon: Icons.people_outline,
                title: 'Отклики моряков',
                subtitle: 'Заявки на ваши вакансии.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Раздел откликов скоро будет в профиле')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _tile(
                context,
                icon: Icons.star_outline,
                title: 'Рейтинг компании',
                subtitle: 'Отзывы моряков о вашем крюинге.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Рейтинг агентств — в разработке')),
                  );
                },
              ),
            ] else ...[
              _tile(
                context,
                icon: Icons.picture_as_pdf,
                title: 'Генератор CV в PDF',
                subtitle: 'Создать международное резюме за 1 клик.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PDF-резюме — скоро')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _tile(
                context,
                icon: Icons.notifications_active,
                title: 'Трекер документов и дипломов',
                subtitle: 'Напоминания о STCW, медкомиссии и сертификатах.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Трекер документов — скоро')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _tile(
                context,
                icon: Icons.rocket_launch,
                title: 'Авторассылка в крюинги',
                subtitle: 'Приоритетная рассылка анкеты для PRO.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Авторассылка — скоро')),
                  );
                },
              ),
            ],
            const SizedBox(height: 24),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Выйти из аккаунта'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _tile(
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
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
        onTap: onTap,
      ),
    );
  }
}
