import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../../application/controllers/auth_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key, required this.authController});

  final AuthController authController;

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);

    InputDecoration decorate() => InputDecoration(
          labelText: l10n.t('email_or_phone'),
          prefixIcon: Icon(IconlyBold.message, color: colors.subtext),
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
        );

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
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
                          Text(
                            l10n.t('reset_password_title'),
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: colors.onSurface),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.t('reset_password_subtitle'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.subtext),
                          ),
                          const SizedBox(height: 24),
                          Form(
                            key: widget.authController.forgotFormKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              decoration: decorate(),
                              onSaved: (value) => widget.authController.forgotEmailOrPhone = value?.trim() ?? '',
                              validator: (value) => widget.authController.validateEmailOrPhone(value, l10n),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: _sending
                                ? null
                                : () async {
                                    final form = widget.authController.forgotFormKey.currentState;
                                    if (form != null && form.validate()) {
                                      form.save();
                                      setState(() => _sending = true);
                                      await widget.authController.sendForgotPassword();
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(l10n.t('reset_link_sent'))),
                                      );
                                      Navigator.of(context).pop();
                                    }
                                    setState(() => _sending = false);
                                  },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                            child: _sending
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : Text(l10n.t('send_reset_link')),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms).slide(begin: const Offset(0, 0.08)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
