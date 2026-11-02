import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  UserModel? get user => _user;

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadCurrentUser() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final profile = await _authService.getCurrentUserProfile();
      _user = profile;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final profile = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = profile;
      return profile;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final profile = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        role: role,
      );
      _user = profile;
      return profile;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _user = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
