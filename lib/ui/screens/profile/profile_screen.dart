import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/routes.dart';
import '../../../state/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final user = appState.user;
    final isGuest = user == null || user.isGuest;
    return Scaffold(
      appBar: AppBar(title: Text(localization.translate('profile'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: theme.colorScheme.primary.withOpacity(.12),
                child: Icon(IconlyBold.profile, color: theme.colorScheme.primary, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? localization.translate('guest'), style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? localization.translate('guest_login'),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (isGuest)
                Chip(
                  label: Text(localization.translate('guest')),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(localization.translate('language'), style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<Locale>(
            value: appState.locale,
            decoration: const InputDecoration(),
            onChanged: (value) {
              if (value != null) appState.setLocale(value);
            },
            items: const [
              DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
              DropdownMenuItem(value: Locale('en'), child: Text('English')),
            ],
          ),
          const SizedBox(height: 24),
          Text(localization.translate('theme'), style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<ThemeMode>(
            value: appState.themeMode,
            decoration: const InputDecoration(),
            onChanged: (value) {
              if (value != null) appState.setTheme(value);
            },
            items: [
              DropdownMenuItem(value: ThemeMode.system, child: Text(localization.translate('system'))),
              DropdownMenuItem(value: ThemeMode.light, child: Text(localization.translate('light'))),
              DropdownMenuItem(value: ThemeMode.dark, child: Text(localization.translate('dark'))),
            ],
          ),
          const SizedBox(height: 24),
          SwitchListTile.adaptive(
            title: Text(localization.translate('notifications')),
            value: appState.notificationsEnabled,
            onChanged: appState.toggleNotifications,
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(localization.translate('about')),
            onTap: () => _showInfo(context, localization.translate('about'), localization.translate('explore_body')),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(localization.translate('policy')),
            onTap: () => _showInfo(context, localization.translate('policy'), 'We respect your privacy.'),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              if (isGuest) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              } else {
                appState.logout();
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              }
            },
            icon: Icon(isGuest ? IconlyLight.login : IconlyLight.logout),
            label: Text(isGuest ? localization.translate('login') : localization.translate('logout')),
          ),
        ],
      ),
    );
  }

  void _showInfo(BuildContext context, String title, String message) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
