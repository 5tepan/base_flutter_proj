import 'package:base_flutter_proj/core/navigation/app_nav_bar.dart';
import 'package:base_flutter_proj/core/navigation/nav_items_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationPage extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavigationPage({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(navItemsProvider);

    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: SafeArea(
        top: false, // иначе внезапно появится лишний отступ сверху
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: AppNavBar(
            height: 64,
            items: items,
            currentIndex: navigationShell.currentIndex,
            onTap: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
        ),
      ),
    );
  }
}
