import 'package:flutter/material.dart';

class ProductsLoading extends StatelessWidget {
  const ProductsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
