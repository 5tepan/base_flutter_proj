import 'package:base_flutter_proj/chat/config/chat_widget_overrides.dart';
import 'package:base_flutter_proj/chat/model/chat_room.dart';
import 'package:base_flutter_proj/core/helpers/date_time_helper.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatListTile extends ConsumerWidget {
  const ChatListTile({
    required this.room,
    required this.onTap,
    super.key,
  });

  final ChatRoom room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = ThemeBuilder.chatStyle;
    final overrides = ref.watch(chatWidgetOverridesProvider);
    final customBuilder = overrides.listTileBuilder;
    if (customBuilder != null) {
      return customBuilder(context, room, onTap);
    }

    return ListTile(
      contentPadding: style.roomPadding,
      leading: CircleAvatar(
        backgroundColor: AppColors.lightGrey,
        child: Text(
          room.title.isNotEmpty ? room.title[0].toUpperCase() : '?',
          style: AppTextStyle.body.copyWith(color: AppColors.primaryColor),
        ),
      ),
      title: Text(room.title, style: AppTextStyle.body),
      subtitle: room.lastMessageText == null
          ? null
          : Text(
              room.lastMessageText!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.small.copyWith(color: AppColors.darkGrey),
            ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (room.lastMessageAt != null)
            Text(
              room.lastMessageAt!.formatSmartDayTime(),
              style: AppTextStyle.small.copyWith(color: AppColors.darkGrey),
            ),
          if (room.unreadCount > 0) ...[
            const SizedBox(height: 4),
            _UnreadBadge(count: room.unreadCount, color: style.unreadBadgeColor),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({
    required this.count,
    required this.color,
  });

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyle.small.copyWith(color: AppColors.white),
      ),
    );
  }
}
