import 'dart:async';

import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/model/chat_message_attachment.dart';
import 'package:base_flutter_proj/chat/provider/chat_list_notifier.dart';
import 'package:base_flutter_proj/chat/provider/chat_messages_notifier.dart';
import 'package:base_flutter_proj/chat/provider/chat_providers.dart';
import 'package:base_flutter_proj/chat/provider/chat_typing_notifier.dart';
import 'package:base_flutter_proj/chat/widgets/chat_message_input.dart';
import 'package:base_flutter_proj/chat/widgets/chat_messages_list.dart';
import 'package:base_flutter_proj/chat/widgets/chat_typing_indicator.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/core/l10n/error_localizer.dart';
import 'package:base_flutter_proj/core/providers/toast_service_provider.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
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
  var _isSending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(chatListProvider.notifier).applyMessageRead(widget.roomId);
      ref.read(chatTypingProvider(widget.roomId).notifier).clear();
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
          ChatTypingIndicator(roomId: widget.roomId),
          ChatMessageInput(
            roomId: widget.roomId,
            enabled: !_isSending,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(
    String text,
    List<MediaFeedItem> attachments,
  ) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty && attachments.isEmpty) {
      return;
    }

    final clientMessageId = 'local_${DateTime.now().millisecondsSinceEpoch}';
    final optimisticMessage = ChatMessage(
      id: clientMessageId,
      roomId: widget.roomId,
      text: trimmedText,
      senderId: 'me',
      senderName: null,
      createdAt: DateTime.now(),
      isOutgoing: true,
      clientMessageId: clientMessageId,
      attachments: ChatMessageAttachment.fromMediaItems(attachments),
    );

    _applyMessage(optimisticMessage);
    setState(() => _isSending = true);

    try {
      final serverMessage = await ref.read(chatRepositoryProvider).sendMessage(
            roomId: widget.roomId,
            text: trimmedText,
            clientMessageId: clientMessageId,
            attachments: attachments,
          );
      _applyMessage(serverMessage);
    } on AppException catch (error) {
      ref.read(chatMessagesProvider(widget.roomId).notifier).removeMessage(
            clientMessageId,
          );
      unawaited(ref.read(chatListProvider.notifier).reload());
      if (!mounted) {
        return;
      }
      ref.read(toastServiceProvider).showError(
            ErrorLocalizer.fromAppException(error, S.of(context)),
          );
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  void _applyMessage(ChatMessage message) {
    ref.read(chatListProvider.notifier).applyIncomingMessage(message);
    if (ref.exists(chatMessagesProvider(widget.roomId))) {
      ref
          .read(chatMessagesProvider(widget.roomId).notifier)
          .applyIncomingMessage(message);
    }
  }
}
