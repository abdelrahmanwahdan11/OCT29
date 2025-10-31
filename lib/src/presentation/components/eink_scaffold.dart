import 'package:flutter/material.dart';

class EInkScaffold extends StatelessWidget {
  const EInkScaffold({super.key, this.appBar, required this.body, this.floatingActionButton});

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: appBar,
      backgroundColor: theme.colorScheme.background,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: body,
        ),
      ),
    );
  }
}
