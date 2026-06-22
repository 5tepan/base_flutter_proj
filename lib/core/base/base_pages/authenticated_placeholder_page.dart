import 'package:base_flutter_proj/auth/providers/auth_providers.dart';
import 'package:base_flutter_proj/auth/route/auth_route.dart';
import 'package:base_flutter_proj/core/base/base_pages/placeholder_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticatedPlaceholderPage extends ConsumerWidget {
  const AuthenticatedPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlaceholderPage(
      onTap: () async {
        await ref.read(authSessionProvider.notifier).signOut();
        if (!context.mounted) {
          return;
        }
        const AuthByPhoneFormRoute().go(context);
      },
    );
  }
}
