import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/routes.dart';
import '../../../state/app_state.dart';

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
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) => value.contains('@') && value.contains('.');

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final appState = AppScope.of(context);
    setState(() => _isSubmitting = true);
    try {
      await appState.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localization.translate('register'))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(localization.translate('register'), style: theme.textTheme.displayLarge),
                const SizedBox(height: 8),
                Text(localization.translate('secure_headline'), style: theme.textTheme.bodyLarge),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: localization.translate('name'),
                    prefixIcon: const Icon(IconlyLight.profile),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return localization.translate('validation_required');
                    }
                    if (value.trim().length < 2) {
                      return localization.translate('validation_required');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: localization.translate('email'),
                    prefixIcon: const Icon(IconlyLight.message),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return localization.translate('validation_required');
                    }
                    if (!_isValidEmail(value.trim())) {
                      return localization.translate('validation_email');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: localization.translate('password'),
                    prefixIcon: const Icon(IconlyLight.lock),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(_obscurePassword ? IconlyLight.show : IconlyLight.hide),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return localization.translate('validation_required');
                    }
                    if (value.trim().length < 8) {
                      return localization.translate('validation_password');
                    }
                    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                      return localization.translate('validation_password');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: localization.translate('confirm_password'),
                    prefixIcon: const Icon(IconlyLight.lock),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      icon: Icon(_obscureConfirm ? IconlyLight.show : IconlyLight.hide),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return localization.translate('validation_required');
                    }
                    if (value.trim() != _passwordController.text.trim()) {
                      return localization.translate('validation_password_match');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: _isSubmitting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(IconlyBold.plus),
                  label: Text(localization.translate('register')),
                  onPressed: _isSubmitting ? null : () => _submit(context),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
                  child: Text(localization.translate('login')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
