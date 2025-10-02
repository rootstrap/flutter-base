import 'package:example_presentation/ui/product/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:example_domain/models/product.dart';

class ProductsListWidget extends StatelessWidget {
  final List<Product> products;

  const ProductsListWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (_, index) => ProductWidget(
        product: products[index],
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }
}
