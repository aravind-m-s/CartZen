class CartModel {
  final String id;
  final List products;
  CartModel({required this.id, required this.products});
  Map<String, dynamic> toJson() => {
        'id': id,
        'products': products,
      };
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(id: json['id'], products: json['products']);
  }
}

class CartProductModel {
  final String color;
  final String productId;
  final String size;
  final int quantity;

  CartProductModel({
    required this.color,
    required this.productId,
    required this.size,
    required this.quantity,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
        color: json['color'],
        productId: json['productId'],
        size: json['size'],
        quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() => {
        'color': color,
        'productId': productId,
        'size': size,
        'quantity': quantity,
      };
}
