import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../resources/locale/generated/l10n.dart';

class ProductsEmptyWidget extends StatelessWidget {
  const ProductsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SvgPicture.asset("assets/images/error_ghost.svg", width: 120),
          const SizedBox(height: 16),
          Text(S.of(context).sorryWeDidntFindAnyProduct),
        ],
      ),
    );
  }
}
