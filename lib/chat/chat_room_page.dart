import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/provider/chat_list_notifier.dart';
import 'package:base_flutter_proj/chat/provider/chat_messages_notifier.dart';
import 'package:base_flutter_proj/chat/widgets/chat_message_input.dart';
import 'package:base_flutter_proj/chat/widgets/chat_messages_list.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomPage extends ConsumerStatefulWidget {
  const ChatRoomPage({
    required this.roomId,
    this.title,
    super.key,
  });

  final String roomId;
  final String? title;

  @override
  ConsumerState<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends ConsumerState<ChatRoomPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatListProvider.notifier).applyMessageRead(widget.roomId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesState = ref.watch(chatMessagesProvider(widget.roomId));
    final messagesNotifier = ref.read(chatMessagesProvider(widget.roomId).notifier);
    final resolvedTitle = widget.title ??
        ref
            .watch(chatListProvider)
            .items
            .where((room) => room.id == widget.roomId)
            .map((room) => room.title)
            .firstOrNull ??
        widget.roomId;

    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(title: resolvedTitle),
      body: Column(
        children: [
          Expanded(
            child: ChatMessagesList(
              state: messagesState,
              onRefresh: messagesNotifier.reload,
              onLoadMore: messagesNotifier.loadMore,
              onRetry: messagesNotifier.loadInitial,
            ),
          ),
          ChatMessageInput(
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    final message = ChatMessage(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      roomId: widget.roomId,
      text: text,
      senderId: 'me',
      senderName: null,
      createdAt: DateTime.now(),
      isOutgoing: true,
    );

    ref.read(chatListProvider.notifier).applyIncomingMessage(message);
    if (ref.exists(chatMessagesProvider(widget.roomId))) {
      ref
          .read(chatMessagesProvider(widget.roomId).notifier)
          .applyIncomingMessage(message);
    }
  }
}
