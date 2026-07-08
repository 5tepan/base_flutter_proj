import 'package:base_flutter_proj/chat/api/chat_api.dart';
import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/model/chat_room.dart';
import 'package:base_flutter_proj/core/base/base_api/api_response_parser.dart';
import 'package:base_flutter_proj/core/base/base_api/entities/base_api_response.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:base_flutter_proj/core/helpers/media_upload_helper.dart';
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

  @override
  Future<ChatMessage> sendMessage({
    required String roomId,
    required String text,
    required String clientMessageId,
    List<MediaFeedItem> attachments = const [],
  }) async {
    final path = '$_roomsPath/$roomId/messages';
    final BaseApiResponse response;

    if (attachments.isEmpty) {
      response = await _api.sendPostJsonRequest(
        path,
        body: {
          'text': text,
          'client_message_id': clientMessageId,
        },
      );
    } else {
      final files = await MediaUploadHelper.toMultipartFiles(attachments);
      response = await _api.sendPostRequestWithFiles(
        path,
        files,
        {
          'text': text,
          'client_message_id': clientMessageId,
        },
      );
    }

    return _parseMessage(response);
  }

  @override
  Future<void> sendTypingIndicator({
    required String roomId,
    required bool isTyping,
  }) async {
    final response = await _api.sendPostJsonRequest(
      '$_roomsPath/$roomId/typing',
      body: {'is_typing': isTyping},
    );
    _ensureSuccess(response, defaultCode: AppErrorCode.requestFailed);
  }

  ChatMessage _parseMessage(BaseApiResponse response) {
    final parsed = ApiResponseParser.parseObjectFromResponse<ChatMessage>(
      response,
      key: 'message',
      fromJson: ChatMessage.fromApiJson,
      emptyErrorCode: AppErrorCode.dataNotFound,
    );

    if (parsed.isError || parsed.result == null) {
      throw AppException(
        parsed.errorCode ?? AppErrorCode.sendMessageFailed,
        serverMessage: parsed.serverMessage,
      );
    }

    return parsed.result!;
  }

  void _ensureSuccess(
    BaseApiResponse response, {
    required AppErrorCode defaultCode,
  }) {
    if (response.isError) {
      throw AppException(
        response.errorCode ?? defaultCode,
        serverMessage: response.serverMessage,
      );
    }
  }
}
