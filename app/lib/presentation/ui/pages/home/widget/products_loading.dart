import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductsLoading extends StatelessWidget {
  const ProductsLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: AnimateList(
        onPlay: (controller) => controller.repeat(reverse: true),
        effects: [ShimmerEffect(duration: 1.seconds)],
        children: List<Widget>.generate(
          10,
          (n) => _ListPlaceholder(),
        ),
      ),
    );
  }
}

class _ListPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.black12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 20,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.black26,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 220,
                  height: 20,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 120,
            height: 60,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }
}
