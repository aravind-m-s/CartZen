class OrderModel {
  final List products;
  final String uid;
  final String id;
  final String status;
  final String date;
  final String paymentMethod;
  final Map<String, dynamic> address;
  final String coupon;
  final String total;
  OrderModel({
    required this.products,
    required this.uid,
    required this.id,
    required this.status,
    required this.date,
    required this.paymentMethod,
    required this.coupon,
    required this.total,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        'products': products,
        'uid': uid,
        'id': id,
        'status': status,
        'date': date,
        'paymentMethod': paymentMethod,
        'address': address,
        'coupon': coupon,
        'total': total,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        products: json['products'],
        uid: json['uid'],
        id: json['id'],
        status: json['status'],
        date: json['date'],
        paymentMethod: json['paymentMethod'],
        coupon: json['coupon'],
        total: json['total'],
        address: json['address']);
  }
}
