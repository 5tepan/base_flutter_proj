import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:cross_file/cross_file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message_attachment.g.dart';

enum ChatAttachmentType {
  @JsonValue('photo')
  photo,
  @JsonValue('video')
  video,
  @JsonValue('file')
  file,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ChatMessageAttachment {
  const ChatMessageAttachment({
    required this.id,
    required this.url,
    required this.type,
    this.thumbnailUrl,
  });

  final String id;
  final String url;
  final ChatAttachmentType type;
  final String? thumbnailUrl;

  factory ChatMessageAttachment.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageAttachmentToJson(this);

  factory ChatMessageAttachment.fromApiJson(Map<String, dynamic> json) =>
      ChatMessageAttachment.fromJson(json);

  factory ChatMessageAttachment.fromMediaFeedItem(MediaFeedItem item) {
    return ChatMessageAttachment(
      id: item.id,
      url: item.localFile?.path ?? item.remoteUrl ?? '',
      type: item.isPhoto ? ChatAttachmentType.photo : ChatAttachmentType.video,
      thumbnailUrl: item.thumbnailUrl,
    );
  }

  static List<ChatMessageAttachment> fromMediaItems(List<MediaFeedItem> items) {
    return items.map(ChatMessageAttachment.fromMediaFeedItem).toList();
  }

  MediaFeedItem toMediaFeedItem() {
    final isRemote = url.startsWith('http');
    return MediaFeedItem(
      id: id,
      type: type == ChatAttachmentType.video
          ? MediaFeedItemType.video
          : MediaFeedItemType.photo,
      localFile: isRemote ? null : XFile(url),
      remoteUrl: isRemote ? url : null,
      thumbnailUrl: thumbnailUrl,
    );
  }
}
