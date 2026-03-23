import 'package:base_flutter_proj/core/components/no_internet_connection.dart';
import 'package:base_flutter_proj/core/router/router_provider.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Application extends ConsumerWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Base Flutter',
      theme: ThemeBuilder().buildThemeData(),
      routerConfig: router,
      builder: (context, child) {
        return Stack(children: [child!, const NoInternetConnection()]);
      },
    );
  }
}
