import 'package:base_flutter_proj/chat/api/chat_api.dart';
import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/model/chat_room.dart';
import 'package:base_flutter_proj/core/base/base_api/api_response_parser.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/core/network/core_api.dart';

class ChatApiImpl implements ChatApi {
  ChatApiImpl(this._api);

  final CoreApi _api;

  static const _roomsPath = 'chats/rooms';

  @override
  Future<List<ChatRoom>> fetchRooms({
    required int page,
    required int pageSize,
  }) async {
    final response = await _api.sendGetRequest(
      _roomsPath,
      params: {
        'page': page,
        'pageSize': pageSize,
      },
    );

    final parsed = ApiResponseParser.parseListFromResponse<ChatRoom>(
      response,
      key: 'rooms',
      fromJson: ChatRoom.fromApiJson,
      emptyErrorCode: AppErrorCode.dataNotFound,
    );

    if (parsed.isError || parsed.result == null) {
      throw AppException(
        parsed.errorCode ?? AppErrorCode.requestFailed,
        serverMessage: parsed.serverMessage,
      );
    }

    return parsed.result!;
  }

  @override
  Future<List<ChatMessage>> fetchMessages({
    required String roomId,
    required int page,
    required int pageSize,
  }) async {
    final response = await _api.sendGetRequest(
      '$_roomsPath/$roomId/messages',
      params: {
        'page': page,
        'pageSize': pageSize,
      },
    );

    final parsed = ApiResponseParser.parseListFromResponse<ChatMessage>(
      response,
      key: 'messages',
      fromJson: ChatMessage.fromApiJson,
      emptyErrorCode: AppErrorCode.dataNotFound,
    );

    if (parsed.isError || parsed.result == null) {
      throw AppException(
        parsed.errorCode ?? AppErrorCode.requestFailed,
        serverMessage: parsed.serverMessage,
      );
    }

    return parsed.result!;
  }
}
