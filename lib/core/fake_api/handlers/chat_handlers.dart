import 'dart:convert';

import 'package:base_flutter_proj/core/fake_api/fake_api_constants.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_fixture_loader.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_response.dart';
import 'package:dio/dio.dart';

abstract final class FakeChatHandlers {
  static var _messageCounter = 1000;

  static Future<Response<String>?> handle({
    required String method,
    required String path,
    required Uri url,
    String? body,
  }) async {
    if (path == 'chats/rooms' && method == 'GET') {
      return _rooms(url);
    }

    final messagesMatch = RegExp(
      r'^chats/rooms/([^/]+)/messages$',
    ).firstMatch(path);
    if (messagesMatch != null) {
      final roomId = messagesMatch.group(1)!;
      if (method == 'GET') {
        return _messages(url, roomId);
      }
      if (method == 'POST') {
        return _sendMessage(url, roomId, body);
      }
    }

    final typingMatch = RegExp(
      r'^chats/rooms/([^/]+)/typing$',
    ).firstMatch(path);
    if (typingMatch != null && method == 'POST') {
      return FakeApiResponse.json(url, data: <String, dynamic>{});
    }

    return null;
  }

  static Future<Response<String>> _rooms(Uri url) async {
    final catalog = await FakeApiFixtureLoader.loadJson('chats/rooms.json');
    final rooms = List<Map<String, dynamic>>.from(
      (catalog['rooms'] as List).map(
        (item) => Map<String, dynamic>.from(item as Map),
      ),
    );

    final page = int.tryParse(url.queryParameters['page'] ?? '0') ?? 0;
    final pageSize =
        int.tryParse(url.queryParameters['pageSize'] ?? '20') ?? 20;
    final start = page * pageSize;
    if (start >= rooms.length) {
      return FakeApiResponse.json(url, data: {'rooms': <dynamic>[]});
    }
    final end = (start + pageSize > rooms.length)
        ? rooms.length
        : start + pageSize;
    return FakeApiResponse.json(
      url,
      data: {'rooms': rooms.sublist(start, end)},
    );
  }

  static Future<Response<String>> _messages(Uri url, String roomId) async {
    final roomIndex = int.tryParse(roomId.replaceFirst('room_', ''));
    if (roomIndex == null ||
        roomIndex < 0 ||
        roomIndex >= FakeApiConstants.totalChatRooms) {
      return FakeApiResponse.json(url, data: {'messages': <dynamic>[]});
    }

    final page = int.tryParse(url.queryParameters['page'] ?? '0') ?? 0;
    final pageSize =
        int.tryParse(url.queryParameters['pageSize'] ?? '20') ?? 20;
    final start = page * pageSize;
    if (start >= FakeApiConstants.messagesPerRoom) {
      return FakeApiResponse.json(url, data: {'messages': <dynamic>[]});
    }

    final count = (start + pageSize > FakeApiConstants.messagesPerRoom)
        ? FakeApiConstants.messagesPerRoom - start
        : pageSize;

    final titles = await _roomTitles();
    final title = titles[roomIndex % titles.length];
    final now = DateTime.now().toUtc();
    final messages = List.generate(count, (index) {
      final messageIndex = start + index;
      final isOutgoing = messageIndex.isOdd;
      return {
        'id': '${roomId}_message_$messageIndex',
        'room_id': roomId,
        'text': isOutgoing
            ? 'Моё сообщение №${messageIndex + 1}'
            : 'Ответ собеседника №${messageIndex + 1} в чате «$title»',
        'sender_id': isOutgoing ? 'me' : 'user_$roomIndex',
        'sender_name': isOutgoing ? 'Вы' : title,
        'created_at': now
            .subtract(
              Duration(
                minutes: (FakeApiConstants.messagesPerRoom - messageIndex) * 3,
              ),
            )
            .toIso8601String(),
        'is_outgoing': isOutgoing,
        'attachments': <dynamic>[],
      };
    });

    return FakeApiResponse.json(url, data: {'messages': messages});
  }

  static Future<Response<String>> _sendMessage(
    Uri url,
    String roomId,
    String? body,
  ) async {
    final payload = _decodeBody(body);
    final text = '${payload['text'] ?? ''}';
    final clientMessageId = '${payload['client_message_id'] ?? ''}';
    final now = DateTime.now().toUtc();

    return FakeApiResponse.json(
      url,
      data: {
        'message': {
          'id': '${roomId}_message_${_messageCounter++}',
          'room_id': roomId,
          'text': text,
          'sender_id': 'me',
          'sender_name': 'Вы',
          'created_at': now.toIso8601String(),
          'is_outgoing': true,
          'client_message_id': clientMessageId,
          'attachments': <dynamic>[],
        },
      },
    );
  }

  static Future<List<String>> _roomTitles() async {
    final catalog = await FakeApiFixtureLoader.loadJson('chats/rooms.json');
    return (catalog['rooms'] as List)
        .map((item) => '${(item as Map)['title']}')
        .toList();
  }

  static Map<String, dynamic> _decodeBody(String? body) {
    if (body == null || body.isEmpty) {
      return {};
    }
    // Multipart form fields arrive as plain query-like or already parsed by
    // FakeApiClient into JSON string when possible.
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // ignore — non-JSON body
    }
    return {};
  }
}
