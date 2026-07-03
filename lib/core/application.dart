import 'package:base_flutter_proj/core/components/no_internet_connection.dart';
import 'package:base_flutter_proj/core/config.dart';
import 'package:base_flutter_proj/core/debug/debug_banner_mixin.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/push/push_bridge.dart';
import 'package:base_flutter_proj/core/providers/localizations_provider.dart';
import 'package:base_flutter_proj/core/providers/app_event_bindings.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/providers/theme_provider.dart';
import 'package:base_flutter_proj/core/router/router_provider.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Application extends ConsumerWidget with DebugBannerMixin {
  const Application({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final config = ref.watch(configProvider);
    final packageInfo = ref.watch(packageInfoProvider);
    final themeBuilder = ref.watch(themeBuilderProvider);
    final botToastBuilder = BotToastInit();

    final app = MaterialApp.router(
      title: 'Base Flutter',
      theme: themeBuilder.buildThemeData(),
      routerConfig: router,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: config.supportedLocales,
      locale: config.forcedLocale,
      builder: (context, child) {
        ref.read(currentLocalizationsProvider.notifier).update(S.of(context));
        final wrappedChild = botToastBuilder(context, child);
        return PushBridge(
          child: AppLifecycleBridge(
            child: Stack(children: [wrappedChild, const NoInternetConnection()]),
          ),
        );
      },
    );

    if (!_shouldShowDebugBanner(config)) {
      return app;
    }

    return decorateWithBanner(
      child: app,
      version: '${packageInfo.version}+${packageInfo.buildNumber}',
      onBannerClick: _openTalkerScreen,
    );
  }

  bool _shouldShowDebugBanner(Config config) {
    return config.showDebugBanner && config.flavor == Flavor.dev;
  }

  void _openTalkerScreen() {
    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }

    Navigator.of(navigatorContext).push(
      MaterialPageRoute<void>(
        builder: (_) => TalkerScreen(talker: CustomLogger.talker),
      ),
    );
  }
}
