import 'package:flutter/material.dart';

import 'app.dart';
import 'services/preferences_service.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await PreferencesService.getInstance();
  final appState = AppState(preferences);
  await appState.initialize();
  runApp(AppRoot(appState: appState));
}
