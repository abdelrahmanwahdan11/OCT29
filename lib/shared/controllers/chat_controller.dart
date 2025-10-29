import 'package:flutter/material.dart';

import '../services/clock_sync_mock.dart';
import '../services/notifications_mock.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.from,
    required this.body,
    required this.sentAt,
    this.attachmentUrl,
  });

  final String id;
  final String from;
  final String body;
  final DateTime sentAt;
  final String? attachmentUrl;
}

class ChatThread {
  const ChatThread({required this.id, required this.participantName, required this.messages});

  final String id;
  final String participantName;
  final List<ChatMessage> messages;
}

class ChatController extends ChangeNotifier {
  ChatController({required ClockSyncMock clock, required NotificationsMock notifications})
      : _clock = clock,
        _notifications = notifications;

  final ClockSyncMock _clock;
  final NotificationsMock _notifications;

  final List<ChatThread> _threads = [];

  List<ChatThread> get threads => List.unmodifiable(_threads);

  Future<void> bootstrap() async {
    _threads.clear();
    _threads.add(
      ChatThread(
        id: 'chat_001',
        participantName: 'Hassan',
        messages: [
          ChatMessage(
            id: 'msg_001',
            from: 'Hassan',
            body: 'هل السعر نهائي؟',
            sentAt: _clock.now().subtract(const Duration(minutes: 5)),
          ),
          ChatMessage(
            id: 'msg_002',
            from: 'Me',
            body: 'يمكننا التفاوض بعد فحص المنتج.',
            sentAt: _clock.now().subtract(const Duration(minutes: 2)),
          ),
        ],
      ),
    );
    notifyListeners();
  }

  void sendMessage(String threadId, String body) {
    final thread = _threads.firstWhere((t) => t.id == threadId);
    thread.messages.add(
      ChatMessage(
        id: 'msg_${thread.messages.length + 1}',
        from: 'Me',
        body: body,
        sentAt: _clock.now(),
      ),
    );
    notifyListeners();
    _notifications.push('Message sent to ${thread.participantName}');
  }
}
