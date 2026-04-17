import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/components/app_loading_indicator.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({required this.url, super.key, this.title = 'Документ'});

  final String? url;
  final String title;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            CustomLogger.info('Страница WebView загружена: $url');
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
          onWebResourceError: (error) {
            CustomLogger.error(
              'Ошибка загрузки страницы WebView: ${error.description}',
            );
          },
        ),
      );
    _loadInitialPage();
  }

  void _loadInitialPage() {
    final targetUrl = widget.url;
    if (targetUrl == null || targetUrl.trim().isEmpty) {
      CustomLogger.warning('WebView открыт без URL');
      setState(() => _isLoading = false);
      return;
    }

    CustomLogger.verbose('Переход WebView на страницу $targetUrl');
    _controller.loadRequest(Uri.parse(targetUrl));
  }

  @override
  Widget build(BuildContext context) {
    final targetUrl = widget.url;
    final hasUrl = targetUrl != null && targetUrl.trim().isNotEmpty;

    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(title: widget.title),
      bodyConfig: const AppPageBodyConfig(
        safeArea: false,
        dismissKeyboardOnTap: false,
      ),
      body: Stack(
        children: [
          if (hasUrl)
            WebViewWidget(controller: _controller)
          else
            const Center(
              child: Text(
                'Ссылка для отображения не передана',
                style: AppTextStyle.body,
                textAlign: TextAlign.center,
              ),
            ),
          if (_isLoading && hasUrl)
            const ColoredBox(
              color: AppColors.white,
              child: Center(child: AppLoadingIndicator()),
            ),
        ],
      ),
    );
  }
}
