import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/widgets/chat_message_bubble.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_state.dart';
import 'package:base_flutter_proj/core/components/app_loading_indicator.dart';
import 'package:base_flutter_proj/core/components/base_error_widget.dart';
import 'package:base_flutter_proj/core/components/empty_state_widget.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({
    required this.state,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onRetry,
    super.key,
  });

  final PaginatedState<ChatMessage> state;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final VoidCallback onRetry;

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  static const _loadMoreThreshold = 120.0;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final state = widget.state;

    if (state.showInitialLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (state.hasError && state.items.isEmpty) {
      return BaseErrorWidget.fromError(
        context: context,
        errorCode: state.errorCode!,
        serverMessage: state.serverMessage,
        onPressedButton: widget.onRetry,
      );
    }

    if (state.showEmpty) {
      return EmptyStateWidget(
        title: l10n.chatEmptyTitle,
        subtitle: l10n.chatEmptySubtitle,
        icon: Icons.chat_bubble_outline,
      );
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (state.isLoadingMore || state.isAllLoaded) {
            return false;
          }
          final metrics = notification.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent - _loadMoreThreshold) {
            widget.onLoadMore();
          }
          return false;
        },
        child: ListView.builder(
          reverse: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeBuilder.defaultPadding,
            vertical: 8,
          ),
          itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: AppLoadingIndicator()),
              );
            }

            final messageIndex = state.items.length - 1 - index;
            final message = state.items[messageIndex];
            return ChatMessageBubble(message: message);
          },
        ),
      ),
    );
  }
}
