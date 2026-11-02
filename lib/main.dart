import 'package:flutter/material.dart';

void main() {
  runApp(const FleetWatchApp());
}

class FleetWatchApp extends StatelessWidget {
  const FleetWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FleetWatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B132B),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF87),
          surface: Color(0xFF1C2541),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    JobsScreen(),
    CrewingScreen(),
    SeaTimeScreen(),
    ReviewsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1C2541),
        selectedItemColor: const Color(0xFF00FF87),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Вакансии'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Крюинги'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Ценз'),
          BottomNavigationBarItem(icon: Icon(Icons.rate_review), label: 'Отзывы'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вакансии', style: TextStyle(color: Color(0xFF00FF87), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0B132B),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          JobCard(
            title: 'Chief Engineer (Старший механик)',
            salary: '\$8,500 / mo',
            vessel: 'Container Ship (5000 TEU)',
            contract: '4 months',
            crewing: 'Marlow Navigation',
          ),
          SizedBox(height: 12),
          JobCard(
            title: 'Second Officer (2-й помощник)',
            salary: '\$4,200 / mo',
            vessel: 'Oil Tanker (110,000 DWT)',
            contract: '3+1 months',
            crewing: 'Columbia Shipmanagement',
          ),
          SizedBox(height: 12),
          JobCard(
            title: 'ETO (Электромеханик)',
            salary: '\$6,000 / mo',
            vessel: 'Bulk Carrier',
            contract: '5 months',
            crewing: 'V.Ships Maritime',
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String title;
  final String salary;
  final String vessel;
  final String contract;
  final String crewing;

  const JobCard({
    super.key,
    required this.title,
    required this.salary,
    required this.vessel,
    required this.contract,
    required this.crewing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2541),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Text(
                salary,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF00FF87)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('🚢 $vessel', style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text('⏳ Контракт: $contract', style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text('🏢 Крюинг: $crewing', style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: const BorderSide(color: Color(0xFF00FF87)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {},
              child: const Text('Откликнуться на вакансию', style: TextStyle(color: Color(0xFF00FF87))),
            ),
          ),
        ],
      ),
    );
  }
}

class CrewingScreen extends StatelessWidget {
  const CrewingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Крюинговые компании', style: TextStyle(color: Color(0xFF00FF87)))),
      body: const Center(child: Text('Каталог крюингов и рейтинг', style: TextStyle(color: Colors.white))),
    );
  }
}

class SeaTimeScreen extends StatelessWidget {
  const SeaTimeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Калькулятор Ценза', style: TextStyle(color: Color(0xFF00FF87)))),
      body: const Center(child: Text('Учет плавательного ценза', style: TextStyle(color: Colors.white))),
    );
  }
}

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отзывы о судах и компаниях', style: TextStyle(color: Color(0xFF00FF87)))),
      body: const Center(child: Text('Отзывы моряков', style: TextStyle(color: Colors.white))),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль Моряка', style: TextStyle(color: Color(0xFF00FF87)))),
      body: const Center(child: Text('Паспорт, Документы и Сертификаты', style: TextStyle(color: Colors.white))),
    );
  }
}
