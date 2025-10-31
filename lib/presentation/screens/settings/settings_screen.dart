import 'package:flutter/material.dart';

import '../../../application/controllers/app_controller.dart';
import '../../../application/controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.appController, required this.settingsController});

  final AppController appController;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ListTile(
            title: const Text('Dark mode'),
            trailing: Switch(
              value: appController.themeMode == ThemeMode.dark,
              onChanged: (_) => settingsController.toggleTheme(),
            ),
          ),
          ListTile(
            title: const Text('Primary color'),
            subtitle: const Text('Tap to choose'),
            trailing: CircleAvatar(backgroundColor: appController.primaryColor),
            onTap: () async {
              final color = await showDialog<Color>(
                context: context,
                builder: (_) => _ColorPickerDialog(initial: appController.primaryColor),
              );
              if (color != null) {
                await settingsController.updatePrimaryColor(color);
              }
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(appController.locale.languageCode),
            onTap: () async {
              final locale = await showDialog<Locale>(
                context: context,
                builder: (_) => _LocalePickerDialog(current: appController.locale),
              );
              if (locale != null) {
                await settingsController.updateLocale(locale);
              }
            },
          ),
          ListTile(
            title: const Text('Show Tutorial'),
            onTap: () => Navigator.pushNamed(context, '/tutorial'),
          ),
        ],
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  const _ColorPickerDialog({required this.initial});

  final Color initial;

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select color'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            min: 0,
            max: 360,
            value: HSVColor.fromColor(_color).hue,
            onChanged: (value) {
              setState(() {
                final hsv = HSVColor.fromAHSV(1, value, 0.8, 0.9);
                _color = hsv.toColor();
              });
            },
          ),
          Container(height: 48, width: double.infinity, color: _color),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, _color), child: const Text('Apply')),
      ],
    );
  }
}

class _LocalePickerDialog extends StatelessWidget {
  const _LocalePickerDialog({required this.current});

  final Locale current;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Choose language'),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, const Locale('en')),
          child: Row(
            children: [
              const Text('English'),
              if (current.languageCode == 'en') const Spacer(),
              if (current.languageCode == 'en') const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, const Locale('ar')),
          child: Row(
            children: [
              const Text('العربية'),
              if (current.languageCode == 'ar') const Spacer(),
              if (current.languageCode == 'ar') const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
      ],
    );
  }
}
