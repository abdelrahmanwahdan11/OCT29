import 'package:flutter/material.dart';

import '../../application/controllers/app_controllers.dart';
import '../components/eink_scaffold.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key, required this.controllers});

  final AppControllerRegistry controllers;

  @override
  Widget build(BuildContext context) {
    return EInkScaffold(
      appBar: AppBar(title: const Text('المفضلة')),
      body: const Center(child: Text('يتم حفظ المفضلة محلياً')),
    );
  }
}
