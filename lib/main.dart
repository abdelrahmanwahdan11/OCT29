import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app.dart';
import 'core/env/app_env.dart';
import 'core/storage/shared_prefs_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = SharedPrefsStorage();
  await storage.init();
  final env = AppEnvironment();

  runApp(MazadWantedApp(
    environment: env,
    storage: storage,
  ));
}
