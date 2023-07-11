import 'package:data/models/product_entity.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final String thumbnail;

  Product(this.id, this.title, this.description, this.thumbnail);

  static Product fromEntity(ProductEntity entity) {
    return Product(
      entity.id,
      entity.title,
      entity.description,
      entity.thumbnail,
    );
  }
}
