import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/model/chat_room.dart';
import 'package:base_flutter_proj/chat/provider/chat_providers.dart';
import 'package:base_flutter_proj/chat/repository/chat_repository.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_notifier.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ChatListActions {
  Future<void> reload();
  Future<void> loadMore();
  void clearError();
}

class ChatListNotifier extends PaginatedNotifier<ChatRoom>
    implements ChatListActions {
  late ChatRepository _repository;

  @override
  int get pageSize => 20;

  @override
  PaginatedState<ChatRoom> build() {
    _repository = ref.read(chatRepositoryProvider);
    return super.build();
  }

  @override
  Future<List<ChatRoom>> loadPage(int page) {
    return _repository.fetchRooms(page: page, pageSize: pageSize);
  }

  void applyIncomingMessage(ChatMessage message) {
    final items = List<ChatRoom>.from(state.items);
    final index = items.indexWhere((room) => room.id == message.roomId);

    final ChatRoom updatedRoom;
    if (index >= 0) {
      final room = items.removeAt(index);
      updatedRoom = ChatRoom(
        id: room.id,
        title: room.title,
        lastMessageText: message.text,
        lastMessageAt: message.createdAt ?? DateTime.now(),
        unreadCount: message.isOutgoing
            ? room.unreadCount
            : room.unreadCount + 1,
        avatarUrl: room.avatarUrl,
      );
    } else {
      updatedRoom = ChatRoom(
        id: message.roomId,
        title: message.senderName ?? message.roomId,
        lastMessageText: message.text,
        lastMessageAt: message.createdAt ?? DateTime.now(),
        unreadCount: message.isOutgoing ? 0 : 1,
      );
    }

    items.insert(0, updatedRoom);
    state = state.copyWith(items: items);
  }

  void applyMessageRead(String roomId) {
    final items = state.items
        .map(
          (room) => room.id == roomId
              ? ChatRoom(
                  id: room.id,
                  title: room.title,
                  lastMessageText: room.lastMessageText,
                  lastMessageAt: room.lastMessageAt,
                  avatarUrl: room.avatarUrl,
                )
              : room,
        )
        .toList();

    state = state.copyWith(items: items);
  }
}

final chatListProvider =
    NotifierProvider<ChatListNotifier, PaginatedState<ChatRoom>>(
  ChatListNotifier.new,
);
