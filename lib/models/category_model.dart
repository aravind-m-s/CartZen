class CategoryModel {
  final String id;
  final String category;
  final int offer;
  final String image;
  final bool isDeleted;
  final bool isPercent;
  CategoryModel({
    required this.category,
    required this.offer,
    required this.image,
    this.isDeleted = false,
    this.isPercent = false,
    this.id = '',
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'offer': offer,
        'image': image,
        'isDeleted': isDeleted,
        'isPercent': isPercent,
        'id': id,
      };

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: json['category'],
      offer: json['offer'],
      image: json['image'],
      isDeleted: json['isDeleted'],
      isPercent: json['isPercent'],
      id: json['id'],
    );
  }
}
