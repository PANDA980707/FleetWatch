import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'user_model.dart';

const String apiBase = 'https://fleetwatch-0s4w.onrender.com';

class AuthState {
  final User? user;
  final String? token;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.token, this.isLoading = false, this.error});

  bool get isLoggedIn => user != null;
  bool get hasError => error != null && error!.isNotEmpty;

  AuthState copyWith({User? user, String? token, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(isLoading: true)) {
    _restore();
  }

  String _msg(Object e) {
    if (e is TimeoutException) return 'Сервер не отвечает, попробуйте ещё раз.';
    if (e is FormatException) return 'Неверный ответ сервера.';
    return e.toString().replaceFirst('Exception: ', '').trim();
  }

  Future<void> clearError() async {
    state = state.copyWith(error: null);
  }

  Future<Map<String, dynamic>> _call(
    String method,
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse(apiBase + path);
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    http.Response res;
    if (method == 'GET') {
      res = await http.get(uri, headers: headers).timeout(const Duration(seconds: 60));
    } else {
      res = await http
          .post(uri, headers: headers, body: jsonEncode(body ?? {}))
          .timeout(const Duration(seconds: 60));
    }

    Map<String, dynamic> data = {};
    try {
      data = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    } catch (_) {}

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(data['error'] ?? 'Ошибка сервера (${res.statusCode}).');
    }

    return data;
  }

  User _toUser(Map<String, dynamic> u) => User(
        id: u['email'] as String,
        email: u['email'] as String,
        name: u['name'] as String,
        role: u['role'] == 'agency' ? UserRole.crewing : UserRole.seaman,
      );

  Future<User?> _loadMe(String token) async {
    final data = await _call('GET', '/api/me', token: token);
    final u = data['user'];
    if (u == null) return null;
    return _toUser(u as Map<String, dynamic>);
  }

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        final user = await _loadMe(token);
        if (user != null) {
          state = AuthState(user: user, token: token);
          return;
        }
        await prefs.remove('token');
      }
    } catch (_) {}

    state = const AuthState();
  }

  Future<void> _finish(String token) async {
    final user = await _loadMe(token);
    if (user == null) throw Exception('Не удалось войти.');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    state = AuthState(user: user, token: token, isLoading: false, error: null);
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _call(
        'POST',
        '/api/login',
        body: {'email': email.trim(), 'password': password},
      );
      await _finish(data['token'] as String);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _msg(e));
    }
  }

  Future<void> register(
    String email,
    String password,
    String name,
    UserRole role,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _call(
        'POST',
        '/api/register',
        body: {
          'email': email.trim(),
          'password': password,
          'name': name.trim(),
          'role': role == UserRole.crewing ? 'agency' : 'seaman',
        },
      );
      await _finish(data['token'] as String);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _msg(e));
    }
  }

  Future<void> logout() async {
    final token = state.token;
    state = const AuthState();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      if (token != null) {
        await _call('POST', '/api/logout', token: token);
      }
    } catch (_) {}
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
