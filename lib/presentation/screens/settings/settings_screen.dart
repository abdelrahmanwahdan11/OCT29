import 'package:flutter/material.dart';

import '../../../application/controllers/app_controller.dart';
import '../../../application/controllers/saved_search_controller.dart';
import '../../../application/controllers/settings_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/saved_search.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.appController,
    required this.settingsController,
    required this.savedSearchController,
  });

  final AppController appController;
  final SettingsController settingsController;
  final SavedSearchController savedSearchController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AnimatedBuilder(
            animation: savedSearchController,
            builder: (context, _) {
              final searches = savedSearchController.searches;
              return ExpansionTile(
                title: Text(l10n.t('saved_searches')),
                subtitle: Text('${searches.length} ${l10n.t('saved_label')}'),
                children: searches
                    .map(
                      (SavedSearch search) => ListTile(
                        title: Text(search.query),
                        subtitle: Text(search.filter.brands.isEmpty
                            ? l10n.t('all')
                            : search.filter.brands.join(', ')),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () => savedSearchController.applySearch(search),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final updated = await _renameDialog(context, search.query);
                                if (updated != null && updated.isNotEmpty) {
                                  await savedSearchController.renameSearch(search.id, updated);
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => savedSearchController.deleteSearch(search.id),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          ListTile(
            title: Text(l10n.t('dark_mode')),
            trailing: Switch(
              value: appController.themeMode == ThemeMode.dark,
              onChanged: (_) => settingsController.toggleTheme(),
            ),
          ),
          ListTile(
            title: Text(l10n.t('primary_color')),
            subtitle: Text(l10n.t('tap_to_choose')),
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
            title: Text(l10n.t('language')),
            subtitle: Text(appController.locale.languageCode == 'ar' ? l10n.t('arabic') : l10n.t('english')),
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
            title: Text(l10n.t('show_tutorial')),
            onTap: () => Navigator.pushNamed(context, '/tutorial'),
          ),
          ListTile(
            title: Text(l10n.t('next_phase_title')),
            subtitle: Text(l10n.t('next_phase_subtitle')),
            onTap: () => Navigator.pushNamed(context, '/next_phase'),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }

  Future<String?> _renameDialog(BuildContext context, String current) {
    final controller = TextEditingController(text: current);
    final l10n = AppLocalizations.of(context);
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.t('rename_search')),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l10n.t('name')),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.t('cancel'))),
          TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: Text(l10n.t('save'))),
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
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.t('select_color')),
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
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.t('cancel'))),
        TextButton(onPressed: () => Navigator.pop(context, _color), child: Text(l10n.t('apply'))),
      ],
    );
  }
}

class _LocalePickerDialog extends StatelessWidget {
  const _LocalePickerDialog({required this.current});

  final Locale current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SimpleDialog(
      title: Text(l10n.t('choose_language')),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, const Locale('en')),
          child: Row(
            children: [
              Text(l10n.t('english')),
              if (current.languageCode == 'en') const Spacer(),
              if (current.languageCode == 'en')
                Icon(Icons.check_circle, color: AppColors.of(context).success),
            ],
          ),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, const Locale('ar')),
          child: Row(
            children: [
              Text(l10n.t('arabic')),
              if (current.languageCode == 'ar') const Spacer(),
              if (current.languageCode == 'ar')
                Icon(Icons.check_circle, color: AppColors.of(context).success),
            ],
          ),
        ),
      ],
    );
  }
}
