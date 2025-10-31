import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../../application/controllers/auth_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.authController});

  final AuthController authController;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _loading = false;

  InputDecoration _decorate({
    required AppColors colors,
    required String label,
    IconData? icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon == null ? null : Icon(icon, color: colors.subtext),
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
                                          l10n.t('create_account_title'),
                                          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: colors.onSurface),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          l10n.t('create_account_subtitle'),
                                          style: textTheme.bodyMedium?.copyWith(color: colors.subtext),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pushReplacementNamed(context, '/auth/login'),
                                    child: Text(l10n.t('have_account_login')),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Form(
                                key: widget.authController.signupFormKey,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      textInputAction: TextInputAction.next,
                                      decoration: _decorate(colors: colors, label: l10n.t('full_name'), icon: IconlyBold.profile),
                                      onSaved: (value) => widget.authController.signupName = value?.trim() ?? '',
                                      validator: (value) => widget.authController.validateName(value, l10n),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      decoration: _decorate(colors: colors, label: l10n.t('email'), icon: IconlyBold.message),
                                      onSaved: (value) => widget.authController.signupEmail = value?.trim() ?? '',
                                      validator: (value) => widget.authController.validateEmail(value, l10n),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      decoration: _decorate(colors: colors, label: l10n.t('phone'), icon: IconlyBold.call),
                                      onSaved: (value) => widget.authController.signupPhone = value?.trim() ?? '',
                                      validator: (value) => widget.authController.validatePhone(value, l10n),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      textInputAction: TextInputAction.next,
                                      decoration: _decorate(
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
                                      onSaved: (value) => widget.authController.signupPassword = value?.trim() ?? '',
                                      validator: (value) => widget.authController.validateSignupPassword(value, l10n),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      decoration: _decorate(
                                        colors: colors,
                                        label: l10n.t('confirm_password'),
                                        icon: IconlyBold.lock,
                                        suffix: IconButton(
                                          onPressed: widget.authController.toggleConfirmPasswordVisibility,
                                          icon: Icon(
                                            widget.authController.obscureConfirmPassword ? IconlyLight.show : IconlyLight.hide,
                                            color: colors.subtext,
                                          ),
                                        ),
                                      ),
                                      obscureText: widget.authController.obscureConfirmPassword,
                                      onSaved: (value) => widget.authController.signupConfirmPassword = value?.trim() ?? '',
                                      validator: (value) => widget.authController.validateConfirmPassword(value, l10n),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: _loading
                                    ? null
                                    : () async {
                                        final form = widget.authController.signupFormKey.currentState;
                                        if (form != null && form.validate()) {
                                          form.save();
                                          setState(() => _loading = true);
                                          await widget.authController.signup();
                                          if (!mounted) return;
                                          Navigator.of(context).pushReplacementNamed('/auth/login');
                                        }
                                        setState(() => _loading = false);
                                      },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(56),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                child: _loading
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                    : Text(l10n.t('sign_up')),
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
