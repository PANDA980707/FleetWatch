import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final userDoc = await _db.collection('users').doc(credential.user!.uid).get();
      if (!userDoc.exists) {
        return null;
      }

      return UserModel.fromMap(userDoc.data()!, userDoc.id);
    } on FirebaseAuthException catch (e) {
      throw Exception(_messageFromAuth(e));
    } catch (e) {
      throw Exception('Не удалось войти. Попробуйте ещё раз.');
    }
  }

  Future<UserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = UserModel(
        uid: credential.user!.uid,
        email: email.trim(),
        role: role,
        name: name.trim(),
      );

      await _db.collection('users').doc(credential.user!.uid).set({
        ...user.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      final saved = await _db.collection('users').doc(credential.user!.uid).get();
      return UserModel.fromMap(saved.data()!, saved.id);
    } on FirebaseAuthException catch (e) {
      throw Exception(_messageFromAuth(e));
    } catch (e) {
      throw Exception('Не удалось создать аккаунт.');
    }
  }

  Future<UserModel?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection('users').doc(uid).update(data);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _messageFromAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Пользователь с таким email уже существует.';
      case 'weak-password':
        return 'Пароль слишком слабый.';
      case 'wrong-password':
        return 'Неверный пароль.';
      case 'user-not-found':
        return 'Пользователь не найден.';
      case 'invalid-email':
        return 'Некорректный email.';
      default:
        return e.message ?? 'Ошибка авторизации.';
    }
  }
}
