import 'package:bloc/bloc.dart';
import 'package:cartzen/models/coupon_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'coupon_event.dart';
part 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  CouponBloc() : super(CouponInitial()) {
    on<GetAllCoupon>((event, emit) async {
      await FirebaseFirestore.instance
          .collection('coupons')
          .get()
          .then((value) {
        final List<CouponModel> coupons = [];
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            coupons.add(CouponModel.fromJson(element.data()));
          }
          emit(CouponState(coupons: coupons));
        }
      });
    });
    on<ApplyCoupon>((event, emit) async {
      emit(CouponState(coupons: state.coupons, coupon: event.coupon));
    });
    on<AddUserToCoupon>((event, emit) async {
      await FirebaseFirestore.instance
          .collection('coupons')
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          late CouponModel coupon;
          value.docs.forEach((element) {
            final cpn = CouponModel.fromJson(element.data());
            if (cpn.couponCode == event.coupon) {
              coupon = cpn;
            }
            coupon.redeemedUsers.add(FirebaseAuth.instance.currentUser!.uid);
            FirebaseFirestore.instance
                .collection('coupons')
                .doc(coupon.id)
                .update(coupon.toJson());
          });
        }
      });
    });
  }
}
