import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حول التطبيق')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Text('AutoInk v0.1\nتطبيق تجريبي لسوق السيارات بأسلوب e-ink.'),
      ),
    );
  }
}
