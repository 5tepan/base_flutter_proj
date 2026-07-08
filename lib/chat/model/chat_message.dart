import 'package:base_flutter_proj/chat/model/chat_message_attachment.dart';
import 'package:base_flutter_proj/core/base/base_api/custom_json_formatters.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.roomId,
    required this.text,
    required this.senderId,
    required this.createdAt,
    this.senderName,
    this.isOutgoing = false,
    this.clientMessageId,
    this.attachments = const [],
  });

  final String id;
  final String roomId;
  final String text;
  final String senderId;
  final String? senderName;

  @DateTimeJsonConverter()
  final DateTime? createdAt;

  final bool isOutgoing;
  final String? clientMessageId;
  final List<ChatMessageAttachment> attachments;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  factory ChatMessage.fromApiJson(Map<String, dynamic> json) =>
      ChatMessage.fromJson(json);

  List<MediaFeedItem> toMediaFeedItems() {
    return attachments.map((attachment) => attachment.toMediaFeedItem()).toList();
  }
}
