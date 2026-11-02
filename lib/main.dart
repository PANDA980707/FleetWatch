import 'package:flutter/material.dart';

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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E676),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  String _selectedRole = 'seaman';
  final _emailController = TextEditingController(text: 'demo@fleetwatch.com');
  final _passwordController = TextEditingController(text: '123456');
  final _nameController = TextEditingController();

  void _submit() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните Email и Пароль')),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainTabScreen(userRole: _selectedRole),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Icon(Icons.anchor_rounded, size: 72, color: Color(0xFF00E676)),
                const SizedBox(height: 12),
                const Text(
                  'FLEETWATCH',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                const Text('Maritime Recruitment Network', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 36),
                
                if (!_isLogin) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('🌊 Моряк')),
                          selected: _selectedRole == 'seaman',
                          selectedColor: const Color(0xFF00E676),
                          backgroundColor: const Color(0xFF1E293B),
                          labelStyle: TextStyle(
                            color: _selectedRole == 'seaman' ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (_) => setState(() => _selectedRole = 'seaman'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('🏢 Крюинг')),
                          selected: _selectedRole == 'crewing',
                          selectedColor: const Color(0xFF00E676),
                          backgroundColor: const Color(0xFF1E293B),
                          labelStyle: TextStyle(
                            color: _selectedRole == 'crewing' ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (_) => setState(() => _selectedRole = 'crewing'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: _selectedRole == 'seaman' ? 'ФИО / Должность' : 'Название компании',
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF00E676)),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email, color: Color(0xFF00E676)),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Пароль',
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF00E676)),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _submit,
                    child: Text(_isLogin ? 'ВОЙТИ' : 'ЗАРЕГИСТРИРОВАТЬСЯ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin ? 'Создать новый аккаунт' : 'Уже есть аккаунт? Войти',
                    style: const TextStyle(color: Color(0xFF00E676)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainTabScreen extends StatefulWidget {
  final String userRole;
  const MainTabScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      JobsTab(userRole: widget.userRole),
      const AgenciesTab(),
      ProfileTab(userRole: widget.userRole),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: const Color(0xFF00E676),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.directions_boat), label: 'Вакансии'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Крюинги'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}

class JobsTab extends StatefulWidget {
  final String userRole;
  const JobsTab({Key? key, required this.userRole}) : super(key: key);

  @override
  State<JobsTab> createState() => _JobsTabState();
}

class _JobsTabState extends State<JobsTab> {
  final List> _jobs = [
    {
      'title': 'Chief Engineer (Старший механик)',
      'vessel': 'Container Ship (5000 TEU)',
      'salary': '\$8,500 / mo',
      'duration': '4 months',
      'agency': 'Marlow Navigation',
      'applied': false,
    },
    {
      'title': 'Second Officer (2-й помощник)',
      'vessel': 'Oil Tanker (110,000 DWT)',
      'salary': '\$4,200 / mo',
      'duration': '3+1 months',
      'agency': 'Columbia Shipmanagement',
      'applied': false,
    },
    {
      'title': 'ETO (Электромеханик)',
      'vessel': 'Bulk Carrier',
      'salary': '\$6,000 / mo',
      'duration': '5 months',
      'agency': 'V.Ships Maritime',
      'applied': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вакансии'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF00E676)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Фильтр по типу судов и зарплате')),
              );
            },
          ),
        ],
      ),
      floatingActionButton: widget.userRole == 'crewing'
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF00E676),
              foregroundColor: Colors.black,
              icon: const Icon(Icons.add),
              label: const Text('Опубликовать'),
              onPressed: () => _showAddJobModal(context),
            )
          : null,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          return Card(
            color: const Color(0xFF1E293B),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          job['title'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        job['salary'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00E676)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('🚢 ${job['vessel']}', style: const TextStyle(color: Colors.white70)),
                  Text('⏳ Контракт: ${job['duration']}', style: const TextStyle(color: Colors.white70)),
                  Text('🏢 Крюинг: ${job['agency']}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: job['applied'] ? Colors.grey : const Color(0xFF00E676)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        setState(() {
                          job['applied'] = !job['applied'];
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              job['applied'] ? 'Заявка отправлена в ${job['agency']}!' : 'Заявка отозвана',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        job['applied'] ? 'Вы откликнулись ✓' : 'Откликнуться на вакансию',
                        style: TextStyle(
                          color: job['applied'] ? Colors.grey : const Color(0xFF00E676),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddJobModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Новая вакансия', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Должность (например, 2nd Engineer)')),
            const TextField(decoration: InputDecoration(labelText: 'Тип судна')),
            const TextField(decoration: InputDecoration(labelText: 'Оклад (\$ / мес)')),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676), foregroundColor: Colors.black),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Вакансия опубликована в системе!')),
                );
              },
              child: const Text('Опубликовать'),
            ),
          ],
        ),
      ),
    );
  }
}

class AgenciesTab extends StatelessWidget {
  const AgenciesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final agencies = [
      {'name': 'Marlow Navigation', 'rating': 4.9, 'reviews': 128, 'location': 'Лимассол / Одесса'},
      {'name': 'Columbia Shipmanagement', 'rating': 4.7, 'reviews': 94, 'location': 'Гамбург / Клайпеда'},
      {'name': 'V.Ships', 'rating': 4.5, 'reviews': 210, 'location': 'Монако / Рига'},
      {'name': 'BSM (Bernhard Schulte)', 'rating': 4.8, 'reviews': 156, 'location': 'Сингапур'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Крюинговые Агентства'), backgroundColor: const Color(0xFF1E293B)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: agencies.length,
        itemBuilder: (context, index) {
          final agency = agencies[index];
          return Card(
            color: const Color(0xFF1E293B),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF00E676),
                child: Icon(Icons.business, color: Colors.black),
              ),
              title: Text(agency['name'].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('📍 ${agency['location']}\n💬 Отзывов: ${agency['reviews']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    agency['rating'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: const Color(0xFF1E293B),
                    title: Text(agency['name'].toString()),
                    content: Text('Рейтинг: ${agency['rating']} ⭐\nЛокация: ${agency['location']}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Закрыть', style: TextStyle(color: Color(0xFF00E676))),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ProfileTab extends StatefulWidget {
  final String userRole;
  const ProfileTab({Key? key, required this.userRole}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFF00E676),
              child: Icon(Icons.person, size: 54, color: Colors.black),
            ),
            const SizedBox(height: 12),
            Text(
              widget.userRole == 'seaman' ? 'Капитан Александр' : 'ООО Крюинг Сервис',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.userRole == 'seaman' ? 'Master / Captain (FG)' : 'Лицензированное агентство',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            if (widget.userRole == 'seaman') ...[
              SwitchListTile(
                title: const Text('Готов к выходу в рейс (Ready for sea)'),
                subtitle: Text(_isAvailable ? 'Статус: Открыт к предложениям' : 'Статус: В рейсе / Отпуск'),
                activeColor: const Color(0xFF00E676),
                value: _isAvailable,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),
              const Divider(color: Colors.white24),
              const ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Color(0xFF00E676)),
                title: Text('Мое резюме (CV_Captain.pdf)'),
                subtitle: Text('Загружено 3 дня назад'),
                trailing: Icon(Icons.upload_file),
              ),
              const ListTile(
                leading: Icon(Icons.verified, color: Color(0xFF00E676)),
                title: Text('Рабочий диплом & STCW'),
                subtitle: Text('Подтверждено 8 сертификатов'),
              ),
            ],

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.edit, color: Color(0xFF00E676)),
                label: const Text('Редактировать профиль'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Режим редактирования данных')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
