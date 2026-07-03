import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_state.dart';
import 'package:base_flutter_proj/core/components/app_loading_indicator.dart';
import 'package:base_flutter_proj/core/components/base_error_widget.dart';
import 'package:flutter/material.dart';

/// Общая обёртка для paginated list/grid: состояния + refresh + load more.
class PaginatedScrollView<T> extends StatelessWidget {
  const PaginatedScrollView({
    required this.state,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onRetry,
    required this.builder,
    super.key,
    this.empty,
    this.loadMoreThreshold = 200,
  });

  final PaginatedState<T> state;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final VoidCallback onRetry;
  final Widget? empty;
  final double loadMoreThreshold;
  final Widget Function(BuildContext context, ScrollPhysics physics) builder;

  @override
  Widget build(BuildContext context) {
    if (state.showInitialLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (state.hasError && state.items.isEmpty) {
      return BaseErrorWidget.fromError(
        context: context,
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
        child: builder(context, const AlwaysScrollableScrollPhysics()),
      ),
    );
  }
}
