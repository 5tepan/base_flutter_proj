import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/model/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ChatListTileBuilder =
    Widget Function(
      BuildContext context,
      ChatRoom room,
      VoidCallback onTap,
    );

typedef ChatMessageBubbleBuilder =
    Widget Function(BuildContext context, ChatMessage message);

/// Опциональные кастомные builders чата (не зависят от глобальной темы).
class ChatWidgetOverrides {
  const ChatWidgetOverrides({
    this.listTileBuilder,
    this.messageBubbleBuilder,
  });

  final ChatListTileBuilder? listTileBuilder;
  final ChatMessageBubbleBuilder? messageBubbleBuilder;
}

final chatWidgetOverridesProvider = Provider<ChatWidgetOverrides>((ref) {
  return const ChatWidgetOverrides();
});
