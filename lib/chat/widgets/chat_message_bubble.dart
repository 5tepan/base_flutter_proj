import 'package:base_flutter_proj/chat/config/chat_widget_overrides.dart';
import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/core/components/media/feed/media_feed_strip.dart';
import 'package:base_flutter_proj/core/helpers/date_time_helper.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessageBubble extends ConsumerWidget {
  const ChatMessageBubble({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = ThemeBuilder.chatStyle;
    final overrides = ref.watch(chatWidgetOverridesProvider);
    final customBuilder = overrides.messageBubbleBuilder;
    if (customBuilder != null) {
      return customBuilder(context, message);
    }

    final isOutgoing = message.isOutgoing;
    final bubbleColor = isOutgoing
        ? style.outgoingBubbleColor
        : style.incomingBubbleColor;
    final textColor = isOutgoing
        ? style.outgoingTextColor
        : style.incomingTextColor;
    final mediaItems = message.toMediaFeedItems();

    return Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: style.messageSpacing / 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: style.bubbleBorderRadius,
        ),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isOutgoing && (message.senderName?.isNotEmpty ?? false))
              Text(
                message.senderName!,
                style: AppTextStyle.small.copyWith(
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (message.text.isNotEmpty)
              Text(
                message.text,
                style: AppTextStyle.body.copyWith(color: textColor),
              ),
            if (mediaItems.isNotEmpty)
              MediaFeedStrip(
                items: mediaItems,
                editable: false,
              ),
            if (message.createdAt != null)
              Text(
                message.createdAt!.formatTime(),
                style: AppTextStyle.small.copyWith(
                  color: textColor.withValues(alpha: 0.75),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
