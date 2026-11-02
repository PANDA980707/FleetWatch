pkg update
pkg install nodejs
termux-setup-storage
ls ~/storage/downloads
pkg install unzip
cd ~/storage/downloads
unzip -o ship-info-server-1.zip -d ~/
ls ~/ship-info-server
unzip -o ship-info-server.zip -d ~/
cd ~/ship-info-server
npm instal
AISSTREAM_API_KEY=ваш_ключ ADMIN_EMAIL=ваш@email.com node server.js
fhgry
ftd2
hak
rjfjj
jfjrijcc fcbcjdnd xkду.ппзе
ада
а
45рва
mkdir -p lib/features/auth
cat << 'EOF' > lib/features/auth/user_model.dart
enum UserRole { seaman, crewing }

class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role.name,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        role: UserRole.values.byName(json['role'] as String),
      );
}
EOF

cat << 'EOF' > lib/features/auth/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_model.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isLoggedIn => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = User(
        id: '1',
        email: email,
        name: 'Моряк',
        role: UserRole.seaman,
      );

      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(String email, String password, String name, UserRole role) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        role: role,
      );

      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
EOF

cat << 'EOF' > lib/features/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('FleetWatch — Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Пароль'),
            ),
            const SizedBox(height: 24),
            if (authState.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () {
                  ref.read(authProvider.notifier).login(
                        _emailController.text,
                        _passwordController.text,
                      );
                },
                child: const Text('Войти'),
              ),
            TextButton(
              onPressed: () => context.go('/register'),
              child: const Text('Регистрация'),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

cat << 'EOF' > lib/features/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';
import 'user_model.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  UserRole _selectedRole = UserRole.seaman;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('FleetWatch — Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Имя / Название компании'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Пароль'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<UserRole>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Роль'),
                items: const [
                  DropdownMenuItem(
                    value: UserRole.seaman,
                    child: Text('Моряк'),
                  ),
                  DropdownMenuItem(
                    value: UserRole.crewing,
                    child: Text('Крюинговая компания'),
                  ),
                ],
                onChanged: (role) {
                  if (role != null) setState(() => _selectedRole = role);
                },
              ),
              const SizedBox(height: 24),
              if (authState.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).register(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text,
                          _selectedRole,
                        );
                  },
                  child: const Text('Зарегистрироваться'),
                ),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Уже есть аккаунт? Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
EOF

mkdir -p lib/features/home
cat << 'EOF' > lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    final List<Widget> pages = [
      const Center(
        child: Text(
          'Список вакансий (в разработке)',
          style: TextStyle(fontSize: 18),
        ),
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Имя: ${authState.user?.name ?? "Неизвестно"}'),
            const SizedBox(height: 8),
            Text('Email: ${authState.user?.email ?? "—"}'),
            const SizedBox(height: 8),
            Text('Роль: ${authState.user?.role.name ?? "—"}'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(authProvider.notifier).logout(),
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Выйти'),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'FleetWatch — Вакансии' : 'Профиль'),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Вакансии',
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
EOF

cat << 'EOF' > lib/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      const isLoginOrRegister = state.uri.path == '/login' || state.uri.path == '/register';

      if (!isLoggedIn && !isLoginOrRegister) {
        return '/login';
      }
      if (isLoggedIn && isLoginOrRegister) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
});
EOF

cat << 'EOF' > lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: FleetWatchApp(),
    ),
  );
}

class FleetWatchApp extends ConsumerWidget {
  const FleetWatchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'FleetWatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
EOF

flutter analyze
flutter run
flutter analyze
flutter run
export PATH="$HOME/flutter/bin:$PATH"
find ~ -name flutter -type f
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
flutter analyze
export PATH="$HOME/flutter/bin:$PATH"
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
flutter analyze
find / -name flutter -type d 2>/dev/null
export PATH="ВАШ_ПУТЬ/bin:$PATH"
find ~ -maxdepth 3 -name "flutter"
pkg update && pkg install git wget curl pkg-config libandroid-spawn -y
mkdir -p ~/development && cd ~/development
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.6-stable.tar.xz
tar xf flutter_linux_3.19.6-stable.tar.xz
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
pkg install xz-utils -y
tar xf flutter_linux_3.19.6-stable.tar.xz
flutter --version
pkg install xz-utils -y && tar xf flutter_linux_3.19.6-stable.tar.xz
cd ~/development
rm -rf flutter flutter_linux_3.19.6-stable.tar.xz
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$HOME/development/flutter/bin:$PATH"
flutter --version
pkg install proot-distro -y
proot-distro install ubuntu
proot-distro login ubuntu
cd ~ && flutter create --org com.fleetwatch --project-name fleet_watch fleet_watch && cd fleet_watch
exit
proot-distro login ubuntu
