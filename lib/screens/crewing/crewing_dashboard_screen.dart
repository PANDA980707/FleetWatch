import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CrewingDashboardScreen extends StatefulWidget {
  const CrewingDashboardScreen({super.key});

  @override
  State<CrewingDashboardScreen> createState() => _CrewingDashboardScreenState();
}

class _CrewingDashboardScreenState extends State<CrewingDashboardScreen> {
  int _index = 0;

  final List<Widget> _pages = const [
    _CreateVacancyPlaceholder(),
    _ApplicationsPlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FleetWatch • Крюинг'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.add_circle_outline_rounded), label: 'Вакансии'),
          NavigationDestination(icon: Icon(Icons.assignment_ind_outlined), label: 'Отклики'),
        ],
      ),
    );
  }
}

class _CreateVacancyPlaceholder extends StatelessWidget {
  const _CreateVacancyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Экран создания вакансии для крюинга'),
    );
  }
}

class _ApplicationsPlaceholder extends StatelessWidget {
  const _ApplicationsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Экран откликов для крюинга'),
    );
  }
}
