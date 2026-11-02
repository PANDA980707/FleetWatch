import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_controller.dart';
import 'screens/auth/auth_wrapper.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FleetWatchApp());
}

class FleetWatchApp extends StatelessWidget {
  const FleetWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: MaterialApp(
        title: 'FleetWatch',
        debugShowCheckedModeBanner: false,
        theme: fleetwatchTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}
