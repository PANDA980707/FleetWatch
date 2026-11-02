import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/main_container.dart';

void main() {
  runApp(const FleetWatchApp());
}

class FleetWatchApp extends StatelessWidget {
  const FleetWatchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FleetWatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B132B),
        primaryColor: const Color(0xFF00FF87),
      ),
      home: const SplashInitializer(),
    );
  }
}

class SplashInitializer extends StatefulWidget {
  const SplashInitializer({Key? key}) : super(key: key);

  @override
  _SplashInitializerState createState() => _SplashInitializerState();
}

class _SplashInitializerState extends State<SplashInitializer> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainContainer()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
