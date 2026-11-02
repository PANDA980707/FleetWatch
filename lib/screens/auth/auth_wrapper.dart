import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_controller.dart';
import '../screens/crewing/crewing_dashboard_screen.dart';
import '../screens/seafarer/seafarer_home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const LoginScreen();
    }

    if (authController.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final role = authController.user?.role ?? 'seafarer';
    if (role == 'crewing') {
      return const CrewingDashboardScreen();
    }

    return const SeafarerHomeScreen();
  }
}
