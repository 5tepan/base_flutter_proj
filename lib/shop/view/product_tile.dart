import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/shop/model/product.dart';
import 'package:base_flutter_proj/shop/route/shop_route.dart';
import 'package:flutter/material.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name, style: AppTextStyle.body),
      leading: const Icon(Icons.shopping_bag_outlined),
      onTap: () => ShopProductRoute(productId: product.id).push(context),
    );
  }
}

class ProductGridTile extends StatelessWidget {
  const ProductGridTile({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => ShopProductRoute(productId: product.id).push(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 32),
              const SizedBox(height: 8),
              Text(
                product.name,
                style: AppTextStyle.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
