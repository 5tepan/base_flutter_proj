import 'package:base_flutter_proj/chat/provider/chat_typing_notifier.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatTypingIndicator extends ConsumerWidget {
  const ChatTypingIndicator({required this.roomId, super.key});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typingState = ref.watch(chatTypingProvider(roomId));
    if (!typingState.isAnyoneTyping) {
      return const SizedBox.shrink();
    }

    final l10n = S.of(context);
    final names = typingState.typingUserNames.toList(growable: false);
    final label = names.length == 1
        ? l10n.chatTypingSingle(names.first)
        : l10n.chatTypingMultiple;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ThemeBuilder.defaultPadding,
        4,
        ThemeBuilder.defaultPadding,
        0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: AppTextStyle.small.copyWith(color: AppColors.darkGrey),
        ),
      ),
    );
  }
}
