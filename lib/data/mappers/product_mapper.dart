import 'package:flutter_base_rootstrap/data/models/product_entity.dart';
import 'package:flutter_base_rootstrap/domain/models/product.dart';

extension ProductMapper on ProductEntity {
  Product toDomain() => Product(id, title, description, thumbnail);
}
