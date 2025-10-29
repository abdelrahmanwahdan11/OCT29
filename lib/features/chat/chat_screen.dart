import 'package:flutter/material.dart';

import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/glass_page_scaffold.dart';
import '../../shared/utils/app_localizations.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return GlassPageScaffold(
      title: strings.t('chat'),
      imageUrl: 'https://images.unsplash.com/photo-1520975693418-d2b9311a1b1d?q=80&w=1600',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          ...List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GlassCard(
                child: ListTile(
                  leading: CircleAvatar(child: Text('U${index + 1}')),
                  title: Text('${strings.t('chat_conversations')} ${index + 1}'),
                  subtitle: Text(strings.t('support_tickets')),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
