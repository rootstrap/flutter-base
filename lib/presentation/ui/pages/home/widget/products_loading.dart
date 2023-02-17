import 'package:flutter/material.dart';

import '../../../../../domain/models/product.dart';

class ProductsLoading extends StatelessWidget {
  const ProductsLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
