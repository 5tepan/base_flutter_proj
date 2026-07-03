import 'package:base_flutter_proj/auth/providers/auth_providers.dart';
import 'package:base_flutter_proj/auth/route/auth_route.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:base_flutter_proj/profile/route/profile_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Экран профиля с переходом к демо-компонентам.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);

    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(
        title: l10n.navProfile,
        actionsWidget: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authSessionProvider.notifier).signOut();
              if (!context.mounted) {
                return;
              }
              const AuthByPhoneFormRoute().go(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.science_outlined),
            title: Text(l10n.profileDemoSectionTitle),
            subtitle: Text(l10n.profileDemoSectionSubtitle),
          ),
          ListTile(
            leading: const Icon(Icons.perm_media_outlined),
            title: Text(l10n.profileMediaDemoTitle),
            subtitle: Text(l10n.profileMediaDemoSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => const MediaFilesDemoRoute().push(context),
          ),
        ],
      ),
    );
  }
}
