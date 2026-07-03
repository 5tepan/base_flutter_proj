import 'package:base_flutter_proj/core/components/sharing/app_share.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';

typedef AppShareButtonBuilder =
    Widget Function(BuildContext context, VoidCallback onPressed);

/// Кнопка шаринга ссылки, текста или файлов.
class AppShareButton extends StatelessWidget {
  AppShareButton({
    super.key,
    this.url,
    this.text,
    this.filePaths = const [],
    this.subject,
    this.label,
    this.icon = Icons.share_outlined,
    this.builder,
  }) : assert(
         (url != null && url.isNotEmpty) ||
             (text != null && text.isNotEmpty) ||
             filePaths.isNotEmpty,
         'Укажите url, text или filePaths.',
       );

  final String? url;
  final String? text;
  final List<String> filePaths;
  final String? subject;
  final String? label;
  final IconData icon;
  final AppShareButtonBuilder? builder;

  @override
  Widget build(BuildContext context) {
    final resolvedLabel = label ?? S.of(context).shareButton;
    return builder?.call(context, _onPressed) ??
        IconButton(
          tooltip: resolvedLabel,
          icon: Icon(icon),
          onPressed: _onPressed,
        );
  }

  Future<void> _onPressed() async {
    if (filePaths.isNotEmpty) {
      await AppShare.shareFiles(
        paths: filePaths,
        text: text,
        subject: subject,
      );
      return;
    }

    if (url != null && url!.isNotEmpty) {
      await AppShare.shareLink(
        url: url!,
        text: text,
        subject: subject,
      );
      return;
    }

    final shareText = text;
    if (shareText != null && shareText.isNotEmpty) {
      await AppShare.shareText(text: shareText, subject: subject);
    }
  }
}

/// Текстовая кнопка шаринга ссылки.
class AppShareLinkButton extends StatelessWidget {
  const AppShareLinkButton({
    super.key,
    required this.url,
    this.text,
    this.subject,
    this.label,
    this.icon = Icons.link,
  });

  final String url;
  final String? text;
  final String? subject;
  final String? label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => AppShare.shareLink(
        url: url,
        text: text,
        subject: subject,
      ),
      icon: Icon(icon),
      label: Text(label ?? S.of(context).shareLinkButton),
    );
  }
}
