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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1D9BF0),
          surface: Color(0xFF16181C),
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF16181C)),
      ),
    );
  }
}
