import 'dart:async';

import 'package:base_flutter_proj/chat/api/chat_api.dart';
import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/model/chat_message_attachment.dart';
import 'package:base_flutter_proj/chat/model/chat_room.dart';
import 'package:base_flutter_proj/chat/socket/chat_socket_constants.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';

/// Mock API для dev без бэкенда.
class MockChatApi implements ChatApi {
  MockChatApi({this.emitSocketEvent});

  final void Function(String eventName, Map<String, dynamic> data)?
  emitSocketEvent;

  static const Duration _latency = Duration(milliseconds: 350);
  static const int totalRooms = 12;
  static const int messagesPerRoom = 48;

  var _messageCounter = 1000;
  final _typingStartTimers = <String, Timer>{};
  final _typingStopTimers = <String, Timer>{};
  final _activeMockTypingRooms = <String>{};

  static const _mockTypingUserId = 'user_support';

  @override
  Future<List<ChatRoom>> fetchRooms({
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(_latency);

    final start = page * pageSize;
    if (start >= totalRooms) {
      return [];
    }

    final count = (start + pageSize > totalRooms)
        ? totalRooms - start
        : pageSize;

    return List.generate(count, (index) => _roomAt(start + index));
  }

  @override
  Future<List<ChatMessage>> fetchMessages({
    required String roomId,
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(_latency);

    final roomIndex = int.tryParse(roomId.replaceFirst('room_', ''));
    if (roomIndex == null || roomIndex < 0 || roomIndex >= totalRooms) {
      return [];
    }

    final start = page * pageSize;
    if (start >= messagesPerRoom) {
      return [];
    }

    final count = (start + pageSize > messagesPerRoom)
        ? messagesPerRoom - start
        : pageSize;

    return List.generate(
      count,
      (index) => _messageAt(
        roomId: roomId,
        roomIndex: roomIndex,
        messageIndex: start + index,
      ),
    );
  }

  @override
  Future<ChatMessage> sendMessage({
    required String roomId,
    required String text,
    required String clientMessageId,
    List<MediaFeedItem> attachments = const [],
  }) async {
    await Future<void>.delayed(_latency);

    final serverAttachments = ChatMessageAttachment.fromMediaItems(attachments)
        .map(
          (attachment) => ChatMessageAttachment(
            id: attachment.id,
            url: attachment.url.startsWith('http')
                ? attachment.url
                : 'https://picsum.photos/seed/${attachment.id}/400/300',
            type: attachment.type,
            thumbnailUrl: attachment.thumbnailUrl,
          ),
        )
        .toList();

    return ChatMessage(
      id: '${roomId}_message_${_messageCounter++}',
      roomId: roomId,
      text: text,
      senderId: 'me',
      senderName: 'Вы',
      createdAt: DateTime.now(),
      isOutgoing: true,
      clientMessageId: clientMessageId,
      attachments: serverAttachments,
    );
  }

  @override
  Future<void> sendTypingIndicator({
    required String roomId,
    required bool isTyping,
  }) async {
    final emit = emitSocketEvent;
    if (emit == null) {
      return;
    }

    if (!isTyping) {
      _typingStartTimers.remove(roomId)?.cancel();
      _typingStopTimers.remove(roomId)?.cancel();
      if (_activeMockTypingRooms.remove(roomId)) {
        emit(ChatSocketEvents.typingStop, {
          'room_id': roomId,
          'user_id': _mockTypingUserId,
        });
      }
      return;
    }

    _typingStartTimers.remove(roomId)?.cancel();
    _typingStartTimers[roomId] = Timer(const Duration(milliseconds: 800), () {
      _typingStartTimers.remove(roomId);
      _activeMockTypingRooms.add(roomId);
      emit(ChatSocketEvents.typingStart, {
        'room_id': roomId,
        'user_id': _mockTypingUserId,
        'user_name': _roomTitles[1],
      });

      _typingStopTimers.remove(roomId)?.cancel();
      _typingStopTimers[roomId] = Timer(const Duration(seconds: 3), () {
        _typingStopTimers.remove(roomId);
        if (_activeMockTypingRooms.remove(roomId)) {
          emit(ChatSocketEvents.typingStop, {
            'room_id': roomId,
            'user_id': _mockTypingUserId,
          });
        }
      });
    });
  }

  static ChatRoom _roomAt(int index) {
    final now = DateTime.now();
    return ChatRoom(
      id: 'room_$index',
      title: _roomTitles[index % _roomTitles.length],
      lastMessageText: _lastMessages[index % _lastMessages.length],
      lastMessageAt: now.subtract(Duration(minutes: index * 17 + 3)),
      unreadCount: index.isEven ? 0 : (index % 4) + 1,
    );
  }

  static ChatMessage _messageAt({
    required String roomId,
    required int roomIndex,
    required int messageIndex,
  }) {
    final isOutgoing = messageIndex.isOdd;
    final now = DateTime.now();
    return ChatMessage(
      id: '${roomId}_message_$messageIndex',
      roomId: roomId,
      text: isOutgoing
          ? 'Моё сообщение №${messageIndex + 1}'
          : 'Ответ собеседника №${messageIndex + 1} в чате «${_roomTitles[roomIndex % _roomTitles.length]}»',
      senderId: isOutgoing ? 'me' : 'user_$roomIndex',
      senderName: isOutgoing ? 'Вы' : _roomTitles[roomIndex % _roomTitles.length],
      createdAt: now.subtract(
        Duration(minutes: (messagesPerRoom - messageIndex) * 3),
      ),
      isOutgoing: isOutgoing,
    );
  }

  static const _roomTitles = [
    'Поддержка',
    'Менеджер Анна',
    'Доставка',
    'Василий Петров',
    'Мария К.',
    'Отдел продаж',
  ];

  static const _lastMessages = [
    'Добрый день! Чем могу помочь?',
    'Заказ уже в пути',
    'Спасибо, всё получилось',
    'Можете уточнить адрес?',
    'Хорошо, жду звонка',
    'Отправили счёт на почту',
  ];
}
