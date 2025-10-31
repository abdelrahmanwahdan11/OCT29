import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../application/controllers/app_controller.dart';
import '../../../application/controllers/auth_controller.dart';
import '../../../core/localization/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.appController, required this.authController});

  final AppController appController;
  final AuthController authController;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: widget.authController.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email or phone',
                    prefixIcon: Icon(IconlyBold.message),
                  ),
                  onSaved: (value) => widget.authController.loginEmailOrPhone = value ?? '',
                  validator: widget.authController.validateEmailOrPhone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(IconlyBold.lock),
                    suffixIcon: IconButton(
                      icon: Icon(widget.authController.obscurePassword ? IconlyLight.show : IconlyLight.hide),
                      onPressed: () => setState(widget.authController.togglePasswordVisibility),
                    ),
                  ),
                  obscureText: widget.authController.obscurePassword,
                  onSaved: (value) => widget.authController.loginPassword = value ?? '',
                  validator: widget.authController.validatePassword,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/auth/forgot'),
                      child: const Text('Forgot password?'),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/auth/signup'),
                      child: const Text('Create account'),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () async {
                          final form = widget.authController.loginFormKey.currentState;
                          if (form != null && form.validate()) {
                            form.save();
                            setState(() => _loading = true);
                            final user = await widget.authController.login();
                            await widget.appController.setUser(user);
                            if (!mounted) return;
                            Navigator.of(context).pushReplacementNamed('/home');
                          }
                          setState(() => _loading = false);
                        },
                  child: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Login'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    await widget.appController.ensureGuestSession();
                    if (!mounted) return;
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  child: Text(l10n.t('guest')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
