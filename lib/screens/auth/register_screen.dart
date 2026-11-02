import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_controller.dart';
import '../../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _role = 'seafarer';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<AuthController>();
    final user = await controller.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      role: _role,
    );

    if (user != null && mounted) {
      // role redirect handled by AuthWrapper
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                color: AppColors.panel,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 78,
                            height: 78,
                            decoration: BoxDecoration(
                              color: AppColors.emerald.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: AppColors.emerald.withOpacity(0.4)),
                            ),
                            child: const Icon(Icons.person_add_alt_rounded, size: 36, color: AppColors.emerald),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Создать аккаунт',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Присоединяйтесь к FleetWatch',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(labelText: 'Имя / ФИО'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Введите имя';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Введите email';
                            if (!value.contains('@')) return 'Введите корректный email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(labelText: 'Пароль'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Введите пароль';
                            if (value.length < 6) return 'Пароль должен содержать минимум 6 символов';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _role,
                          dropdownColor: AppColors.panelAlt,
                          decoration: const InputDecoration(labelText: 'Роль'),
                          items: const [
                            DropdownMenuItem(value: 'seafarer', child: Text('Моряк')),
                            DropdownMenuItem(value: 'crewing', child: Text('Крюинг')),
                          ],
                          onChanged: (value) {
                            if (value != null) setState(() => _role = value);
                          },
                        ),
                        const SizedBox(height: 22),
                        if (controller.errorMessage != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.red),
                            ),
                            child: Text(
                              controller.errorMessage!,
                              style: const TextStyle(color: AppColors.textPrimary),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: controller.isLoading ? null : _submit,
                          child: controller.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                  ),
                                )
                              : const Text('Зарегистрироваться'),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Уже есть аккаунт? Войти',
                            style: TextStyle(
                              color: AppColors.emerald,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
