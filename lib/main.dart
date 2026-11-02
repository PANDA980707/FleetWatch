import 'package:flutter/material.dart';

import 'package:fleetwatch/theme/app_theme.dart';

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
      theme: fleetwatchTheme,
      home: const _AppShell(),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('FleetWatch ready'),
      ),
    );
  }
}
