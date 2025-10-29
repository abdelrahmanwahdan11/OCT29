import 'package:flutter/material.dart';

import 'frosted_app_bar.dart';
import 'gradient_background.dart';

class GlassPageScaffold extends StatelessWidget {
  const GlassPageScaffold({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.body,
    this.actions,
  });

  final String title;
  final String imageUrl;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: GradientBackground(
        imageUrl: imageUrl,
        child: SafeArea(
          child: Column(
            children: [
              FrostedAppBar(
                title: Text(title),
                actions: actions,
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}
