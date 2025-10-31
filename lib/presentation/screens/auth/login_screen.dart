import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../../application/controllers/app_controller.dart';
import '../../../application/controllers/auth_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.appController, required this.authController});

  final AppController appController;
  final AuthController authController;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  InputDecoration _decorateField({
    required AppLocalizations l10n,
    required AppColors colors,
    required String label,
    IconData? icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon == null
          ? null
          : Icon(icon, color: colors.subtext),
      suffixIcon: suffix,
      filled: true,
      fillColor: colors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: colors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: colors.accent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: colors.error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedBuilder(
              animation: widget.authController,
              builder: (context, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 48, maxWidth: 520),
                    child: Center(
                      child: IntrinsicHeight(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: colors.accent.withOpacity(0.12),
                                blurRadius: 32,
                                offset: const Offset(0, 24),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.t('welcome_back'),
                                          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: colors.onSurface),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          l10n.t('login_subtitle'),
                                          style: textTheme.bodyMedium?.copyWith(color: colors.subtext),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pushReplacementNamed(context, '/auth/signup'),
                                    child: Text(l10n.t('create_account')),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Form(
                                key: widget.authController.loginFormKey,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      decoration: _decorateField(
                                        l10n: l10n,
                                        colors: colors,
                                        label: l10n.t('email_or_phone'),
                                        icon: IconlyBold.message,
                                      ),
                                      onSaved: (value) => widget.authController.loginEmailOrPhone = value?.trim() ?? '',
                                      validator: (value) => widget.authController.validateEmailOrPhone(value, l10n),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      textInputAction: TextInputAction.done,
                                      decoration: _decorateField(
                                        l10n: l10n,
                                        colors: colors,
                                        label: l10n.t('password'),
                                        icon: IconlyBold.lock,
                                        suffix: IconButton(
                                          onPressed: widget.authController.togglePasswordVisibility,
                                          icon: Icon(
                                            widget.authController.obscurePassword ? IconlyLight.show : IconlyLight.hide,
                                            color: colors.subtext,
                                          ),
                                        ),
                                      ),
                                      obscureText: widget.authController.obscurePassword,
                                      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                                      onSaved: (value) => widget.authController.loginPassword = value?.trim() ?? '',
                                      validator: (value) => widget.authController.validatePassword(value, l10n),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: TextButton(
                                        onPressed: () => Navigator.pushNamed(context, '/auth/forgot'),
                                        child: Text(l10n.t('forgot_password')),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
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
                                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                                    child: _loading
                                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                        : Text(l10n.t('login_cta')),
                                  ),
                                  const SizedBox(height: 12),
                                  OutlinedButton(
                                    onPressed: () async {
                                      await widget.appController.ensureGuestSession();
                                      if (!mounted) return;
                                      Navigator.of(context).pushReplacementNamed('/home');
                                    },
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(56),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    ),
                                    child: Text(l10n.t('guest')),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 300.ms).slide(begin: const Offset(0, 0.08)),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
