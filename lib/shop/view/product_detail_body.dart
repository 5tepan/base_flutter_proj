import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:base_flutter_proj/shop/entities/product.dart';
import 'package:flutter/material.dart';

class ProductDetailBody extends StatelessWidget {
  const ProductDetailBody({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return ListView(
      children: [
        Text(product.name, style: AppTextStyle.title),
        const SizedBox(height: 8),
        Text(
          product.id,
          style: AppTextStyle.small.copyWith(color: AppColors.grey90),
        ),
        if (product.description != null) ...[
          const SizedBox(height: 16),
          Text(l10n.shopProductDescription, style: AppTextStyle.body),
          const SizedBox(height: 4),
          Text(product.description!, style: AppTextStyle.body),
        ],
      ],
    );
  }
}
