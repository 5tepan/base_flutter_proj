import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/provider/chat_providers.dart';
import 'package:base_flutter_proj/chat/repository/chat_repository.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_notifier.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ChatMessagesActions {
  Future<void> reload();
  Future<void> loadMore();
  void clearError();
}

class ChatMessagesNotifier extends PaginatedNotifier<ChatMessage>
    implements ChatMessagesActions {
  ChatMessagesNotifier(this.roomId);

  final String roomId;

  late ChatRepository _repository;

  @override
  int get pageSize => 30;

  @override
  PaginatedState<ChatMessage> build() {
    _repository = ref.read(chatRepositoryProvider);
    return super.build();
  }

  @override
  Future<List<ChatMessage>> loadPage(int page) {
    return _repository.fetchMessages(
      roomId: roomId,
      page: page,
      pageSize: pageSize,
    );
  }

  void applyIncomingMessage(ChatMessage message) {
    if (message.roomId != roomId) {
      return;
    }

    final items = List<ChatMessage>.from(state.items);
    final clientMessageId = message.clientMessageId;
    if (clientMessageId != null) {
      final optimisticIndex = items.indexWhere((item) => item.id == clientMessageId);
      if (optimisticIndex >= 0) {
        items[optimisticIndex] = message;
        state = state.copyWith(items: items);
        return;
      }
    }

    if (items.any((item) => item.id == message.id)) {
      return;
    }

    items.add(message);
    state = state.copyWith(items: items);
  }

  void removeMessage(String messageId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != messageId).toList(),
    );
  }
}

final chatMessagesProvider = NotifierProvider.family<
    ChatMessagesNotifier,
    PaginatedState<ChatMessage>,
    String>(
  ChatMessagesNotifier.new,
);
