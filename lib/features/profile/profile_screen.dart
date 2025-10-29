import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../shared/controllers/app_controller.dart';
import '../../shared/controllers/auth_controller.dart';
import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/glass_chip.dart';
import '../../shared/ui_kit/glass_badge.dart';
import '../../shared/ui_kit/pill_button.dart';
import '../../shared/utils/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.authController, required this.appController});

  final AuthController authController;
  final AppController appController;

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser;
    final strings = MazadLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (user != null)
          GlassCard(
            child: Column(
              children: [
                CircleAvatar(radius: 48, backgroundImage: NetworkImage(user.avatarUrl)),
                const SizedBox(height: 12),
                Text(user.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GlassChip(label: user.email),
                const SizedBox(height: 8),
                GlassBadge(label: '${strings.t('reviews_feedback')} ${user.reputation}'),
                const SizedBox(height: 16),
                PillButton(
                  label: strings.t('logout'),
                  onPressed: () => authController.logout(),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms).scale(begin: const Offset(0.95, 0.95)),
        const SizedBox(height: 24),
        Text(strings.t('settings'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            children: [
              SwitchListTile(
                title: Text(strings.t('settings_theme')),
                value: appController.themeMode == ThemeMode.dark,
                onChanged: (value) => appController.setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
              ),
              SwitchListTile(
                title: Text(strings.t('settings_language')),
                value: appController.locale.languageCode == 'ar',
                onChanged: (value) => appController.setLocale(value ? const Locale('ar') : const Locale('en')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
