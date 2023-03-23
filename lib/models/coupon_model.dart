class CouponModel {
  final String id;
  final int offer;
  final bool isPercent;
  final String couponCode;
  final String startDate;
  final String endDate;
  final List redeemedUsers;
  final int max;
  CouponModel({
    required this.id,
    required this.offer,
    required this.isPercent,
    required this.couponCode,
    required this.startDate,
    required this.endDate,
    required this.redeemedUsers,
    required this.max,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'offer': offer,
        'isPercent': isPercent,
        'couponCode': couponCode,
        'startDate': startDate,
        'endDate': endDate,
        'redeemedUsers': redeemedUsers,
        'max': max,
      };

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
        id: json['id'],
        max: json['max'],
        offer: json['offer'],
        isPercent: json['isPercent'],
        couponCode: json['couponCode'],
        startDate: json['startDate'],
        redeemedUsers: json['redeemedUsers'],
        endDate: json['endDate']);
  }
}
