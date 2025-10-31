import 'package:flutter/material.dart';

import '../../application/controllers/app_controllers.dart';

class InterestOfferTile extends StatelessWidget {
  const InterestOfferTile({super.key, required this.offer});

  final AppNotification offer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(offer.title, style: theme.textTheme.titleMedium),
      subtitle: Text(offer.message, style: theme.textTheme.bodyMedium),
      trailing: Text('${offer.createdAt.hour}:${offer.createdAt.minute.toString().padLeft(2, '0')}'),
    );
  }
}
