import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SeafarerHomeScreen extends StatefulWidget {
  const SeafarerHomeScreen({super.key});

  @override
  State<SeafarerHomeScreen> createState() => _SeafarerHomeScreenState();
}

class _SeafarerHomeScreenState extends State<SeafarerHomeScreen> {
  int _index = 0;

  final List<Widget> _pages = const [
    _JobsPlaceholder(),
    _ProfilePlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FleetWatch • Моряк'),
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
          NavigationDestination(icon: Icon(Icons.work_outline_rounded), label: 'Вакансии'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'Профиль'),
        ],
      ),
    );
  }
}

class _JobsPlaceholder extends StatelessWidget {
  const _JobsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Экран вакансий для моряка'),
    );
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Экран профиля моряка'),
    );
  }
}
