import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'screens/main_container.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(authProvider, (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final path = state.uri.path;
      final onAuthPage = path == '/login' || path == '/register';
      if (auth.isLoggedIn && onAuthPage) return '/';
      if (!auth.isLoggedIn && !onAuthPage) return '/login';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MainContainer()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    ],
  );
});
