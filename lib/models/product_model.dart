class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final int stock;
  final int offer;
  final bool isDeleted;
  final bool isPercent;
  final List images;
  final List sizes;
  final List colors;
  final int price;
  final List keywords;

  ProductModel({
    required this.sizes,
    required this.colors,
    required this.keywords,
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.images,
    required this.stock,
    required this.price,
    this.isDeleted = false,
    this.isPercent = false,
    this.offer = 0,
  });

  Map<String, dynamic> toJson() => {
        'sizes': sizes,
        'isPercent': isPercent,
        'colors': colors,
        'keywords': keywords,
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'images': images,
        'stock': stock,
        'offer': offer,
        'isDeleted': isDeleted,
        'price': price,
      };

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      sizes: json['sizes'],
      colors: json['colors'],
      keywords: json['keywords'],
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      images: json['images'],
      offer: json['offer'],
      stock: json['stock'],
      isDeleted: json['isDeleted'],
      isPercent: json['isPercent'],
      price: json['price'],
    );
  }
}
