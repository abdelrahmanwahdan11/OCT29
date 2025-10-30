import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../widgets/password_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  static final _emailRegex =
      RegExp('^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}\\$');
  static final _passwordRegex = RegExp('^(?=.*\\d).{8,}\\$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final appState = AppStateScope.of(context);
      await appState.signup(email: _emailController.text.trim());
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.string('signup')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: l10n.string('email')),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !_emailRegex.hasMatch(value.trim())) {
                      return l10n.string('invalid_email');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _passwordController,
                  label: l10n.string('password'),
                  validator: (value) {
                    if (value == null || !_passwordRegex.hasMatch(value)) {
                      return l10n.string('invalid_password');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _confirmController,
                  label: l10n.string('confirm_password'),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return l10n.string('passwords_not_match');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => _submit(context),
                  child: Text(l10n.string('sign_up')),
                ),
                const SizedBox(height: 12),
                Wrap(
                  children: [
                    Text(l10n.string('have_account')),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.string('sign_in')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
