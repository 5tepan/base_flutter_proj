import 'package:base_flutter_proj/chat/api/chat_api.dart';
import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/model/chat_room.dart';

/// Mock API для dev без бэкенда.
class MockChatApi implements ChatApi {
  static const Duration _latency = Duration(milliseconds: 350);
  static const int totalRooms = 12;
  static const int messagesPerRoom = 48;

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
