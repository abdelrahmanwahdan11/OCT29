import 'package:flutter/material.dart';

import '../../shared/controllers/app_controller.dart';
import '../../shared/controllers/app_scope.dart';
import '../../shared/controllers/catalog_controller.dart';
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
  AppController? _appController;
  CatalogController? _catalogController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = InheritedAppScope.of(context);
    if (_appController != scope.appController) {
      _appController?.removeListener(_rebuild);
      _appController = scope.appController..addListener(_rebuild);
    }
    if (_catalogController != scope.catalogController) {
      _catalogController?.removeListener(_rebuild);
      _catalogController = scope.catalogController..addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    _appController?.removeListener(_rebuild);
    _catalogController?.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = InheritedAppScope.of(context);
    final strings = MazadLocalizations.of(context);
    final themeMode = scope.appController.themeMode;
    final locale = scope.appController.locale;
    final density = scope.appController.density == VisualDensity.compact ? 'compact' : 'comfortable';
    final savedSearches = scope.catalogController.savedSearches;
    final seedOptions = <Color>[
      const Color(0xFF0EA5E9),
      const Color(0xFF22C55E),
      const Color(0xFFA78BFA),
      const Color(0xFFFF8E3C),
      const Color(0xFF38BDF8),
    ];
    if (!seedOptions.contains(scope.appController.seedColor)) {
      seedOptions.insert(0, scope.appController.seedColor);
    }

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
                Text(strings.t('settings_density'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'comfortable', label: Text(strings.t('density_comfortable'))),
                    ButtonSegment(value: 'compact', label: Text(strings.t('density_compact'))),
                  ],
                  selected: {density},
                  onSelectionChanged: (value) {
                    if (value.first == 'compact') {
                      scope.appController.toggleDensity();
                    } else if (density == 'compact') {
                      scope.appController.toggleDensity();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.t('settings_seed_color'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final color in seedOptions)
                      GestureDetector(
                        onTap: () => scope.appController.setSeedColor(color),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(
                              color: scope.appController.seedColor == color
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: scope.appController.seedColor == color
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      ),
                  ],
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
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.t('saved_searches'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (savedSearches.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(strings.t('tap_to_read'), style: Theme.of(context).textTheme.bodyMedium),
                  )
                else
                  for (final search in savedSearches)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(search.query),
                      subtitle: Text(strings.t('scope_${search.scope.name}')),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: strings.t('remove'),
                        onPressed: () => scope.catalogController.removeSavedSearch(search),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
