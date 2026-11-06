import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart';

void main() {
  runApp(const ProviderScope(child: FleetWatchApp()));
}

class FleetWatchApp extends ConsumerWidget {
  const FleetWatchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'FleetWatch',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1D9BF0),
          surface: Color(0xFF16181C),
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF16181C),
          elevation: 0,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1D9BF0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
