import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/routes.dart';
import '../../../state/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    return value.contains('@') && value.contains('.');
  }

  bool _isValidPhone(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 8 && digits.length <= 14;
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final appState = AppScope.of(context);
    setState(() => _isSubmitting = true);
    try {
      await appState.login(email: _emailController.text.trim(), password: _passwordController.text.trim());
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _continueAsGuest(BuildContext context) async {
    final appState = AppScope.of(context);
    await appState.continueAsGuest();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localization.translate('login'))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  localization.translate('welcome_headline'),
                  style: theme.textTheme.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  localization.translate('secure_body'),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: localization.translate('email'),
                    prefixIcon: const Icon(IconlyLight.message),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return localization.translate('validation_required');
                    }
                    if (!_isValidEmail(value.trim()) && !_isValidPhone(value.trim())) {
                      return localization.translate('validation_email');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: localization.translate('password'),
                    prefixIcon: const Icon(IconlyLight.lock),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(_obscure ? IconlyLight.show : IconlyLight.hide),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return localization.translate('validation_required');
                    }
                    if (value.trim().length < 8) {
                      return localization.translate('validation_password');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(localization.translate('forgot_password')),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: _isSubmitting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(IconlyBold.login),
                  label: Text(localization.translate('login')),
                  onPressed: _isSubmitting ? null : () => _submit(context),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _continueAsGuest(context),
                  child: Text(localization.translate('guest_login')),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(localization.translate('register')),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.register),
                      child: Text(localization.translate('register')),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
