import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/storage/shared_prefs_storage.dart';
import '../models/user.dart';

class AuthController extends ChangeNotifier {
  AuthController({required SharedPrefsStorage storage}) : _storage = storage;

  final SharedPrefsStorage _storage;
  static const _prefsKey = 'auth_state_v1';

  User? _currentUser;
  bool _rememberMe = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null && !_currentUser!.isGuest;
  bool get isGuest => _currentUser?.isGuest ?? false;
  bool get rememberMe => _rememberMe;

  void bootstrap() {
    final data = _storage.getString(_prefsKey);
    if (data == null) return;
    try {
      final payload = jsonDecode(data) as Map<String, dynamic>;
      _currentUser = User.fromJson(payload['user'] as Map<String, dynamic>);
      _rememberMe = payload['rememberMe'] as bool? ?? false;
    } catch (_) {
      _currentUser = null;
      _rememberMe = false;
    }
    notifyListeners();
  }

  Future<void> login({required String email, required String password, bool rememberMe = false}) async {
    if (password.length < 8 || !RegExp(r'[A-Za-z]').hasMatch(password) || !RegExp(r'\d').hasMatch(password)) {
      throw const AuthException('Password requirements not met');
    }
    if (!RegExp(r"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}", caseSensitive: false).hasMatch(email)) {
      throw const AuthException('Invalid email');
    }
    _currentUser = User(
      id: 'demo_user',
      name: 'Demo User',
      email: email.toLowerCase(),
      phone: '+966500000000',
      isGuest: false,
      avatarUrl: 'https://randomuser.me/api/portraits/men/31.jpg',
      kycLevel: 1,
      reputation: 4.6,
    );
    _rememberMe = rememberMe;
    await _persist();
    notifyListeners();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().isEmpty) {
      throw const AuthException('Name is required');
    }
    await login(email: email, password: password);
    _currentUser = _currentUser!.copyWith(name: name);
    await _persist();
    notifyListeners();
  }

  Future<void> continueAsGuest() async {
    _currentUser = User(
      id: 'guest',
      name: 'ضيف',
      email: 'guest@mazadwanted.app',
      phone: '',
      isGuest: true,
      avatarUrl: 'https://randomuser.me/api/portraits/lego/2.jpg',
      kycLevel: 0,
      reputation: 0,
    );
    _rememberMe = false;
    await _persist();
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _rememberMe = false;
    await _persist();
    notifyListeners();
  }

  Future<void> setRememberMe(bool remember) async {
    _rememberMe = remember;
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final payload = jsonEncode({
      'user': _currentUser?.toJson(),
      'rememberMe': _rememberMe,
    });
    await _storage.setString(_prefsKey, payload);
  }
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
