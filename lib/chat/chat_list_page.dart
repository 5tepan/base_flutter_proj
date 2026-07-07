import 'package:base_flutter_proj/chat/provider/chat_list_notifier.dart';
import 'package:base_flutter_proj/chat/widgets/chat_list_tile.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_list_layout.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_list_view.dart';
import 'package:base_flutter_proj/core/components/empty_state_widget.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:base_flutter_proj/profile/route/profile_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget _chatListSeparator(BuildContext context, int index) {
  return PaginatedSeparator.divider();
}

class ChatListPage extends ConsumerWidget {
  const ChatListPage({super.key});

  static const _listLayout = PaginatedListLayout(
    separatorBuilder: _chatListSeparator,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    final listState = ref.watch(chatListProvider);
    final notifier = ref.read(chatListProvider.notifier);

    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(title: l10n.chatListTitle),
      body: PaginatedListView(
        state: listState,
        listLayout: _listLayout,
        onRefresh: notifier.reload,
        onLoadMore: notifier.loadMore,
        onRetry: notifier.loadInitial,
        empty: EmptyStateWidget(
          title: l10n.chatListEmptyTitle,
          subtitle: l10n.chatListEmptySubtitle,
          icon: Icons.forum_outlined,
        ),
        itemBuilder: (context, room, index) {
          return ChatListTile(
            room: room,
            onTap: () => ChatRoomRoute(roomId: room.id, title: room.title).push(context),
          );
        },
      ),
    );
  }
}
