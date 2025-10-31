import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class AuthController extends ChangeNotifier {
  AuthController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  String loginEmailOrPhone = '';
  String loginPassword = '';

  String signupName = '';
  String signupEmail = '';
  String signupPhone = '';
  String signupPassword = '';
  String signupConfirmPassword = '';

  String forgotEmailOrPhone = '';

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final emailRegex = RegExp(r'^.+@.+\..+$');
    final phoneRegex = RegExp(r'^[0-9]{8,}$');
    if (emailRegex.hasMatch(value) || phoneRegex.hasMatch(value)) {
      return null;
    }
    return 'Enter a valid email or phone';
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'Use 8+ characters';
    }
    return null;
  }

  String? validateSignupPassword(String? value) {
    if (value == null || value.length < 8) {
      return 'Use 8+ characters';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Add at least one number';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().length < 2) {
      return 'Enter a valid name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final emailRegex = RegExp(r'^.+@.+\..+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || !RegExp(r'^[0-9]{8,}$').hasMatch(value)) {
      return 'Enter a valid phone';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != signupPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<User> login() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: loginEmailOrPhone.contains('@') ? loginEmailOrPhone.split('@').first : 'User',
      email: loginEmailOrPhone.contains('@') ? loginEmailOrPhone : '${loginEmailOrPhone}@guest.app',
      phone: loginEmailOrPhone.contains('@') ? '' : loginEmailOrPhone,
      avatarUrl: '',
      isGuest: false,
    );
  }

  Future<User> signup() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: signupName,
      email: signupEmail,
      phone: signupPhone,
      avatarUrl: '',
      isGuest: false,
    );
  }

  Future<void> sendForgotPassword() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }
}
