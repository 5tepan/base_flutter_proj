import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_state.dart';
import 'package:base_flutter_proj/core/components/app_loading_indicator.dart';
import 'package:base_flutter_proj/core/components/base_error_widget.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Список с пагинацией, pull-to-refresh и обработкой состояний PaginatedState.
class PaginatedListView<T> extends StatelessWidget {
  const PaginatedListView({
    required this.state,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onRetry,
    super.key,
    this.empty,
    this.loadMoreThreshold = 200,
  });

  final PaginatedState<T> state;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final VoidCallback onRetry;
  final Widget? empty;
  final double loadMoreThreshold;

  @override
  Widget build(BuildContext context) {
    if (state.showInitialLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (state.hasError && state.items.isEmpty) {
      return BaseErrorWidget.fromError(
        errorCode: state.errorCode!,
        serverMessage: state.serverMessage,
        onPressedButton: onRetry,
      );
    }

    if (state.showEmpty) {
      return empty ?? const SizedBox.shrink();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (state.isLoadingMore || state.isAllLoaded) {
            return false;
          }
          if (notification.metrics.extentAfter < loadMoreThreshold) {
            onLoadMore();
          }
          return false;
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.items.length) {
              return const Padding(
                padding: EdgeInsets.all(ThemeBuilder.defaultPadding),
                child: Center(child: AppLoadingIndicator()),
              );
            }
            return itemBuilder(context, state.items[index], index);
          },
        ),
      ),
    );
  }
}
