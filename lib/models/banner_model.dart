class BannerModel {
  final String image;
  String id;
  BannerModel({required this.image, this.id = ''});

  Map<String, dynamic> toJson() => {
        'image': image,
        'id': id,
      };

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'],
    );
  }
}
