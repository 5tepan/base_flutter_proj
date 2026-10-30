import 'package:base_flutter_proj/chat/api/chat_api.dart';
import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/model/chat_room.dart';
import 'package:base_flutter_proj/chat/provider/chat_messages_notifier.dart';
import 'package:base_flutter_proj/chat/provider/chat_providers.dart';
import 'package:base_flutter_proj/chat/repository/chat_repository.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('replaces an optimistic message and ignores duplicates', () async {
    final container = ProviderContainer(
      overrides: [
        chatRepositoryProvider.overrideWith(
          (ref) => ChatRepository(_EmptyChatApi()),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(chatMessagesProvider('room-1'), (_, _) {});
    await pumpEventQueue();

    final notifier = container.read(chatMessagesProvider('room-1').notifier);
    notifier.applyIncomingMessage(_message(id: 'local'));
    notifier.applyIncomingMessage(
      _message(id: 'server-1', clientMessageId: 'local'),
    );
    notifier.applyIncomingMessage(_message(id: 'server-1'));
    notifier.applyIncomingMessage(_message(id: 'other', roomId: 'room-2'));

    final items = container.read(chatMessagesProvider('room-1')).items;
    expect(items, hasLength(1));
    expect(items.single.id, 'server-1');
    expect(items.single.clientMessageId, 'local');
  });
}

ChatMessage _message({
  required String id,
  String? clientMessageId,
  String roomId = 'room-1',
}) {
  return ChatMessage(
    id: id,
    roomId: roomId,
    text: 'hi',
    senderId: 'me',
    createdAt: DateTime.utc(2026),
    clientMessageId: clientMessageId,
  );
}

class _EmptyChatApi implements ChatApi {
  @override
  Future<List<ChatMessage>> fetchMessages({
    required String roomId,
    required int page,
    required int pageSize,
  }) async {
    return const [];
  }

  @override
  Future<List<ChatRoom>> fetchRooms({
    required int page,
    required int pageSize,
  }) async {
    return const [];
  }

  @override
  Future<ChatMessage> sendMessage({
    required String roomId,
    required String text,
    required String clientMessageId,
    List<MediaFeedItem> attachments = const [],
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendTypingIndicator({
    required String roomId,
    required bool isTyping,
  }) async {}
}
