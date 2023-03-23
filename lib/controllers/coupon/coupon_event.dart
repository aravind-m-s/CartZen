part of 'coupon_bloc.dart';

@immutable
abstract class CouponEvent {}

class GetAllCoupon extends CouponEvent {}

class ApplyCoupon extends CouponEvent {
  final String coupon;
  ApplyCoupon({required this.coupon});
}

class AddUserToCoupon extends CouponEvent {
  final String coupon;
  AddUserToCoupon({required this.coupon});
}
