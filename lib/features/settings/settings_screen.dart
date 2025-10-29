import 'package:flutter/material.dart';

import '../../shared/controllers/app_scope.dart';
import '../../shared/utils/app_localizations.dart';
import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/glass_page_scaffold.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool privacyEnabled = false;

  @override
  Widget build(BuildContext context) {
    final scope = InheritedAppScope.of(context);
    final strings = MazadLocalizations.of(context);
    final themeMode = scope.appController.themeMode;
    final locale = scope.appController.locale;

    return GlassPageScaffold(
      title: strings.t('settings'),
      imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1600',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.t('settings_theme'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(value: ThemeMode.system, label: Text(strings.t('theme_system'))),
                    ButtonSegment(value: ThemeMode.light, label: Text(strings.t('theme_light'))),
                    ButtonSegment(value: ThemeMode.dark, label: Text(strings.t('theme_dark'))),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (value) => scope.appController.setThemeMode(value.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.t('settings_language'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'ar', label: const Text('العربية')),
                    ButtonSegment(value: 'en', label: const Text('English')),
                  ],
                  selected: {locale.languageCode},
                  onSelectionChanged: (value) => scope.appController.setLocale(Locale(value.first)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.t('settings_notifications'), style: Theme.of(context).textTheme.titleMedium),
                SwitchListTile(
                  title: Text(strings.t('settings_notifications_hint')),
                  value: notificationsEnabled,
                  onChanged: (value) => setState(() => notificationsEnabled = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.t('settings_privacy'), style: Theme.of(context).textTheme.titleMedium),
                SwitchListTile(
                  title: Text(strings.t('settings_privacy_hint')),
                  value: privacyEnabled,
                  onChanged: (value) => setState(() => privacyEnabled = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
