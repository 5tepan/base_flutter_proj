import 'dart:async';

import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_notifier.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads the first page and the next page', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(pageProvider, (_, _) {});

    await pumpEventQueue();

    final notifier = container.read(pageProvider.notifier);
    expect(container.read(pageProvider).items, [1, 2]);
    expect(container.read(pageProvider).isAllLoaded, isFalse);

    await notifier.loadMore();

    expect(container.read(pageProvider).items, [1, 2, 3]);
    expect(container.read(pageProvider).isAllLoaded, isTrue);
    expect(notifier.loads, 2);
  });

  test('a short first page does not request another', () async {
    shortPage = true;
    addTearDown(() => shortPage = false);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(pageProvider, (_, _) {});
    await pumpEventQueue();

    await container.read(pageProvider.notifier).loadMore();

    expect(container.read(pageProvider).items, [1]);
    expect(container.read(pageProvider.notifier).loads, 1);
  });

  test('a failed load exposes an error', () async {
    failPage = true;
    addTearDown(() => failPage = false);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(pageProvider, (_, _) {});
    await pumpEventQueue();

    expect(container.read(pageProvider).hasError, isTrue);
    expect(container.read(pageProvider).isLoading, isFalse);
  });

  test('dispose cancels an in-flight page', () async {
    addTearDown(() {
      if (!slowGate.isCompleted) {
        slowGate.complete();
      }
      slowGate = Completer<void>();
    });
    final container = ProviderContainer();
    container.listen(slowProvider, (_, _) {});
    await Future<void>.delayed(Duration.zero);

    container.dispose();
    if (!slowGate.isCompleted) {
      slowGate.complete();
    }
    await pumpEventQueue();
  });
}

bool shortPage = false;
bool failPage = false;
Completer<void> slowGate = Completer<void>();

final pageProvider = NotifierProvider<_PageNotifier, PaginatedState<int>>(
  _PageNotifier.new,
);

final slowProvider = NotifierProvider<_SlowNotifier, PaginatedState<int>>(
  _SlowNotifier.new,
);

class _PageNotifier extends PaginatedNotifier<int> {
  int loads = 0;

  @override
  int get pageSize => 2;

  @override
  Future<List<int>> loadPage(int page) async {
    loads++;
    if (failPage) {
      throw StateError('boom');
    }
    if (shortPage) {
      return [1];
    }
    return page == 0 ? [1, 2] : [3];
  }
}

class _SlowNotifier extends PaginatedNotifier<int> {
  @override
  int get pageSize => 2;

  @override
  Future<List<int>> loadPage(int page) async {
    await slowGate.future;
    return [1, 2];
  }
}
