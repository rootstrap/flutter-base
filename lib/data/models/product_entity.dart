class ProductEntity {
  final int id;
  final String title;
  final String description;
  final String thumbnail;

  ProductEntity(this.id, this.title, this.description, this.thumbnail);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
    };
  }

  factory ProductEntity.fromMap(Map<String, dynamic> map) {
    return ProductEntity(
      map['id'] as int,
      map['title'] as String,
      map['description'] as String,
      map['thumbnail'] as String,
    );
  }
}
