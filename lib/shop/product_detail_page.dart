import 'package:base_flutter_proj/core/base/base_pages/app_error_page.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/base/model/states/entity_state.dart';
import 'package:base_flutter_proj/core/components/entity_state_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:base_flutter_proj/shop/model/product.dart';
import 'package:base_flutter_proj/shop/providers/product_detail_notifier.dart';
import 'package:base_flutter_proj/shop/view/product_detail_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Эталон детального экрана: ItemNotifier + EntityStateBuilder + AppErrorPage.
class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productDetailProvider(productId));
    final notifier = ref.read(productDetailProvider(productId).notifier);

    if (state case EntityStateError(:final code, :final serverMessage, previous: null)) {
      return AppErrorPage(
        errorCode: code,
        serverMessage: serverMessage,
        onRetry: notifier.reload,
      );
    }

    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(
        title: switch (state) {
          EntityStateData(:final data) => data.name,
          _ => S.of(context).shopProductDetailTitle,
        },
      ),
      body: EntityStateBuilder<Product>(
        state: state,
        onRetry: notifier.reload,
        dataBuilder: (product) => ProductDetailBody(product: product),
      ),
    );
  }
}
