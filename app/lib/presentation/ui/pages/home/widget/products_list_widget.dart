import 'package:flutter/material.dart';
import 'package:example_domain/models/product.dart';
import 'package:app/presentation/ui/pages/home/widget/product_widget.dart';

class ProductsListWidget extends StatelessWidget {
  final List<Product> products;

  const ProductsListWidget({Key? key, required this.products}) : super(key: key);

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
