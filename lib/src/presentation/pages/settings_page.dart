import 'package:flutter/material.dart';

import '../../application/controllers/app_controllers.dart';
import '../../core/localization/app_localizations.dart';
import '../components/color_picker_sheet.dart';
import '../components/eink_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.controllers});

  final AppControllerRegistry controllers;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return EInkScaffold(
      appBar: AppBar(title: Text(localization.translate('settings'))),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text(localization.translate('appearance')),
            subtitle: Text('الوضع الليلي'),
            value: controllers.themeController.themeMode == ThemeMode.dark,
            onChanged: (value) => controllers.themeController.setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
          ),
          ListTile(
            title: Text(localization.translate('primary_color')),
            subtitle: Text(localization.translate('appearance')),
            trailing: CircleAvatar(backgroundColor: controllers.themeController.accentColor),
            onTap: () => showModalBottomSheet<void>(
              context: context,
              builder: (_) => ColorPickerSheet(onColorSelected: (color) {
                controllers.themeController.setAccent(color);
                Navigator.of(context).pop();
              }),
            ),
          ),
          ListTile(
            title: Text(localization.translate('language')),
            subtitle: Text(controllers.localeController.locale.languageCode == 'ar' ? 'العربية' : 'English'),
            onTap: () => controllers.localeController
                .setLocale(controllers.localeController.locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar')),
          ),
          SwitchListTile(
            title: Text(localization.translate('run_tutorial')),
            subtitle: Text(localization.translate('tutorial_toggle_label')),
            value: controllers.coachMarkController.enabled,
            onChanged: controllers.coachMarkController.setEnabled,
          ),
          ListTile(
            title: const Text('إعادة التعيين'),
            subtitle: const Text('مسح البيانات المحلية'),
            onTap: () => _showResetDialog(context),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة التعيين'),
        content: const Text('سيتم مسح البيانات المحلية.'),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              controllers.compareController.clear();
              controllers.notificationController.notifications.value = <AppNotification>[];
              Navigator.of(context).pop();
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}
