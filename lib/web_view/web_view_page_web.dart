import 'dart:html' as html;

import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({required this.url, super.key, this.title = 'Документ'});

  final String? url;
  final String title;

  @override
  Widget build(BuildContext context) {
    final targetUrl = url?.trim();
    final hasUrl = targetUrl != null && targetUrl.isNotEmpty;
    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(title: title),
      body: Center(
        child: hasUrl
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.open_in_browser, size: 48),
                    const SizedBox(height: 16),
                    Text(targetUrl, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        html.AnchorElement(href: targetUrl)
                          ..target = '_blank'
                          ..rel = 'noopener noreferrer'
                          ..click();
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Открыть в браузере'),
                    ),
                  ],
                ),
              )
            : Text(S.of(context).webViewNoUrl),
      ),
    );
  }
}
