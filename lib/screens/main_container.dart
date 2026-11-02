import 'package:flutter/material.dart';
import 'jobs_screen.dart';
import 'crewing_screen.dart';
import 'seatime_screen.dart';
import 'reviews_screen.dart';
import 'profile_screen.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({Key? key}) : super(key: key);

  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const JobsScreen(),
    const CrewingScreen(),
    const SeaTimeScreen(),
    const ReviewsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1C2541),
        selectedItemColor: const Color(0xFF00FF87),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Вакансии',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Крюинги',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Ценз',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Отзывы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
