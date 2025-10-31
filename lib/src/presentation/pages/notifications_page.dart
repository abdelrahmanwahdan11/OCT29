import 'package:flutter/material.dart';

import '../../application/controllers/app_controllers.dart';
import '../components/eink_scaffold.dart';
import '../components/interest_offer_tile.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key, required this.controllers});

  final AppControllerRegistry controllers;

  @override
  Widget build(BuildContext context) {
    return EInkScaffold(
      appBar: AppBar(title: const Text('الإشعارات')),
      body: ValueListenableBuilder<List<AppNotification>>(
        valueListenable: controllers.notificationController.notifications,
        builder: (context, notifications, _) {
          if (notifications.isEmpty) {
            return const Center(child: Text('لا إشعارات حالياً'));
          }
          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) => InterestOfferTile(offer: notifications[index]),
          );
        },
      ),
    );
  }
}
