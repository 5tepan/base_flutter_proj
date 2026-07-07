import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoInternetConnection extends ConsumerWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(internetMonitorProvider).value;
    final show = isConnected == false;

    return IgnorePointer(
      ignoring: !show,
      child: Align(
        alignment: Alignment.topCenter,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 100),
          child: show
              ? Container(
                  width: double.infinity,
                  color: AppColors.lightBlack.withValues(alpha: 0.85),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Text(
                    S.of(context).noInternet,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.apply(color: AppColors.white),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
