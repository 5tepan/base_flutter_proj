import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

Widget appAudioPreview({
  required String path,
  XFile? file,
  required String title,
  required String unavailableMessage,
}) => _AudioPreview(path: file?.path ?? path, title: title);

class _AudioPreview extends StatefulWidget {
  const _AudioPreview({required this.path, required this.title});

  final String path;
  final String title;

  @override
  State<_AudioPreview> createState() => _AudioPreviewState();
}

class _AudioPreviewState extends State<_AudioPreview> {
  final AudioPlayer _player = AudioPlayer();
  var _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    unawaited(_player.setSource(DeviceFileSource(widget.path)));
    _player.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration);
      }
    });
    _player.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.audiotrack,
              size: 72,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: AppTextStyle.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Slider(
              value: _duration.inMilliseconds == 0
                  ? 0
                  : _position.inMilliseconds / _duration.inMilliseconds,
              onChanged: _duration.inMilliseconds == 0
                  ? null
                  : (value) {
                      final target = Duration(
                        milliseconds: (_duration.inMilliseconds * value)
                            .round(),
                      );
                      unawaited(_player.seek(target));
                    },
            ),
            Text('${_format(_position)} / ${_format(_duration)}'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _togglePlayback,
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(
                _isPlaying ? l10n.fileAudioPause : l10n.fileAudioPlay,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
    if (mounted) {
      setState(() => _isPlaying = !_isPlaying);
    }
  }

  String _format(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
