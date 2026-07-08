import 'dart:async';

import 'package:base_flutter_proj/chat/config/chat_defaults.dart';
import 'package:base_flutter_proj/chat/provider/chat_providers.dart';
import 'package:base_flutter_proj/chat/repository/chat_repository.dart';
import 'package:base_flutter_proj/core/components/decorated_text_form_field.dart';
import 'package:base_flutter_proj/core/components/media/feed/media_feed_strip.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_content_mode.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:base_flutter_proj/core/components/media/picker/app_media_picker.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ChatMessageSendCallback =
    void Function(String text, List<MediaFeedItem> attachments);

class ChatMessageInput extends ConsumerStatefulWidget {
  const ChatMessageInput({
    required this.roomId,
    required this.onSend,
    this.enabled = true,
    super.key,
  });

  final String roomId;
  final ChatMessageSendCallback onSend;
  final bool enabled;

  @override
  ConsumerState<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends ConsumerState<ChatMessageInput> {
  static const _typingIdleDuration = Duration(seconds: 3);

  final TextEditingController _controller = TextEditingController();
  final List<MediaFeedItem> _attachments = [];

  Timer? _typingIdleTimer;
  ChatRepository? _repository;
  var _isTypingSent = false;

  @override
  void dispose() {
    _typingIdleTimer?.cancel();
    final repository = _repository;
    if (repository != null && _isTypingSent) {
      unawaited(
        repository.sendTypingIndicator(
          roomId: widget.roomId,
          isTyping: false,
        ),
      );
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _repository = ref.read(chatRepositoryProvider);
    final l10n = S.of(context);
    final style = ThemeBuilder.chatStyle;
    final config = ref.watch(configProvider);

    return Material(
      color: style.inputBackgroundColor,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              if (_attachments.isNotEmpty)
                MediaFeedStrip(
                  items: _attachments,
                  editable: widget.enabled,
                  contentMode: MediaFeedContentMode.photosOnly,
                  maxItems: ChatDefaults.maxAttachmentsPerMessage,
                  imageQuality: config.imagePickerImageQuality,
                  maxWidth: config.imagePickerMaxImageSize,
                  onChanged: widget.enabled
                      ? (items) => setState(() {
                          _attachments
                            ..clear()
                            ..addAll(items);
                        })
                      : null,
                ),
              Row(
                spacing: 8,
                children: [
                  IconButton(
                    onPressed: widget.enabled ? _pickAttachment : null,
                    icon: const Icon(Icons.attach_file_outlined),
                  ),
                  Expanded(
                    child: DecoratedTextFormField(
                      controller: _controller,
                      enabled: widget.enabled,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onChanged: widget.enabled ? _onTextChanged : null,
                      onFieldSubmitted: widget.enabled ? _submit : null,
                      decoration: InputDecoration(
                        hintText: l10n.chatMessageInputHint,
                      ),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: widget.enabled ? _submit : null,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAttachment() async {
    if (_attachments.length >= ChatDefaults.maxAttachmentsPerMessage) {
      return;
    }

    final config = ref.read(configProvider);
    final picked = await AppMediaPicker.pickMedia(
      context: context,
      source: AppMediaPickerSource.gallery,
      contentMode: MediaFeedContentMode.photosOnly,
      imageQuality: config.imagePickerImageQuality,
      maxWidth: config.imagePickerMaxImageSize,
    );

    if (!mounted || picked == null) {
      return;
    }

    setState(() => _attachments.add(picked));
  }

  void _onTextChanged(String? value) {
    final hasText = (value ?? '').trim().isNotEmpty;
    if (!hasText) {
      unawaited(_sendTyping(false));
      return;
    }

    if (!_isTypingSent) {
      unawaited(_sendTyping(true));
    }

    _typingIdleTimer?.cancel();
    _typingIdleTimer = Timer(_typingIdleDuration, () {
      unawaited(_sendTyping(false));
    });
  }

  Future<void> _sendTyping(bool isTyping) async {
    if (!mounted && isTyping) {
      return;
    }

    if (_isTypingSent == isTyping) {
      return;
    }

    _isTypingSent = isTyping;
    final repository = _repository;
    if (repository == null) {
      return;
    }

    await repository.sendTypingIndicator(
      roomId: widget.roomId,
      isTyping: isTyping,
    );
  }

  void _submit([String? value]) {
    final text = (value ?? _controller.text).trim();
    if (text.isEmpty && _attachments.isEmpty) {
      return;
    }

    widget.onSend(text, List<MediaFeedItem>.from(_attachments));
    _controller.clear();
    setState(_attachments.clear);
    _typingIdleTimer?.cancel();
    unawaited(_sendTyping(false));
  }
}
