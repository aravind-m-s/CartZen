part of 'coupon_bloc.dart';

class CouponState {
  final List<CouponModel> coupons;
  final String coupon;
  CouponState({required this.coupons, this.coupon = ''});
}

class CouponInitial extends CouponState {
  CouponInitial() : super(coupons: []);
}
