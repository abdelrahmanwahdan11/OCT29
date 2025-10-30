import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../widgets/password_field.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static final _emailRegex =
      RegExp('^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\$');
  static final _passwordRegex = RegExp('^(?=.*\d).{8,}\$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final appState = AppStateScope.of(context);
      await appState.login(email: _emailController.text.trim());
    }
  }

  void _openSignup(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SharedAxisTransition(
            transitionType: SharedAxisTransitionType.horizontal,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: const SignupPage(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  l10n.string('welcome'),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => _submit(context),
                  child: Text(l10n.string('sign_in')),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => AppStateScope.of(context).loginAsGuest(),
                  child: Text(l10n.string('guest')),
                ),
                const Spacer(),
                Wrap(
                  children: [
                    Text(l10n.string('dont_have_account')),
                    TextButton(
                      onPressed: () => _openSignup(context),
                      child: Text(l10n.string('create_one')),
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

