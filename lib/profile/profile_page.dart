import 'package:base_flutter_proj/auth/providers/auth_providers.dart';
import 'package:base_flutter_proj/auth/route/auth_route.dart';
import 'package:base_flutter_proj/core/assets/app_assets.dart';
import 'package:base_flutter_proj/core/assets/app_icon.dart';
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
            icon: const AppIcon(AppAssets.logout),
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
            leading: const AppIcon(AppAssets.science),
            title: Text(l10n.profileDemoSectionTitle),
            subtitle: Text(l10n.profileDemoSectionSubtitle),
          ),
          ListTile(
            leading: const AppIcon(AppAssets.permMedia),
            title: Text(l10n.profileMediaDemoTitle),
            subtitle: Text(l10n.profileMediaDemoSubtitle),
            trailing: const AppIcon(AppAssets.chevronRight),
            onTap: () => const MediaFilesDemoRoute().go(context),
          ),
          ListTile(
            leading: const AppIcon(AppAssets.calendar),
            title: Text(l10n.profileCalendarDemoTitle),
            subtitle: Text(l10n.profileCalendarDemoSubtitle),
            trailing: const AppIcon(AppAssets.chevronRight),
            onTap: () => const CalendarDemoRoute().go(context),
          ),
          ListTile(
            leading: const AppIcon(AppAssets.textFields),
            title: const Text('Dynamic form demo'),
            subtitle: const Text(
              'MVP динамических форм: schema-driven UI + валидация',
            ),
            trailing: const AppIcon(AppAssets.chevronRight),
            onTap: () => const DynamicFormDemoRoute().go(context),
          ),
          ListTile(
            leading: const AppIcon(AppAssets.map),
            title: Text(l10n.profileMapDemoTitle),
            subtitle: Text(l10n.profileMapDemoSubtitle),
            trailing: const AppIcon(AppAssets.chevronRight),
            onTap: () => const MapDemoRoute().go(context),
          ),
          ListTile(
            leading: const AppIcon(AppAssets.chat),
            title: Text(l10n.profileChatDirectDemoTitle),
            subtitle: Text(l10n.profileChatDirectDemoSubtitle),
            trailing: const AppIcon(AppAssets.chevronRight),
            onTap: () => const ChatDirectRoute().go(context),
          ),
          ListTile(
            leading: const AppIcon(AppAssets.forum),
            title: Text(l10n.profileChatDemoTitle),
            subtitle: Text(l10n.profileChatDemoSubtitle),
            trailing: const AppIcon(AppAssets.chevronRight),
            onTap: () => const ChatListRoute().go(context),
          ),
        ],
      ),
    );
  }
}
