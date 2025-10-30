import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../state/app_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = appState.initialRoute;
      if (ModalRoute.of(context)?.settings.name != route) {
        Navigator.of(context).pushReplacementNamed(route);
      }
    });
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(localizations.translate('loading')),
          ],
        ),
      ),
    );
  }
}
