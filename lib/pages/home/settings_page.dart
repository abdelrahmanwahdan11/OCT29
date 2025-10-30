import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appState = AppStateScope.of(context);
    final themeMode = appState.themeMode;
    final locale = appState.locale;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.string('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.string('theme'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                icon: const Icon(Icons.phone_android),
                label: Text(l10n.string('system')),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: const Icon(Icons.light_mode),
                label: Text(l10n.string('light')),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: const Icon(Icons.dark_mode),
                label: Text(l10n.string('dark')),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (selection) {
              final mode = selection.first;
              appState.setThemeMode(mode);
            },
          ),
          const SizedBox(height: 32),
          Text(
            l10n.string('language'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: locale.languageCode,
            decoration: InputDecoration(
              labelText: l10n.string('language'),
            ),
            items: const [
              DropdownMenuItem(
                value: 'ar',
                child: Text('العربية'),
              ),
              DropdownMenuItem(
                value: 'en',
                child: Text('English'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              appState.setLocale(Locale(value));
            },
          ),
        ],
      ),
    );
  }
}
