import 'package:bloc/bloc.dart';
import 'package:cartzen/models/product_model.dart';
import 'package:cartzen/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'whishlist_event.dart';
part 'whishlist_state.dart';

class WhishlistBloc extends Bloc<WhishlistEvent, WhishlistState> {
  WhishlistBloc() : super(WhishlistInitial()) {
    on<GetAllWishListProducts>((event, emit) async {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((value) async {
        if (value.data() != null) {
          final user = UserModel.fromJson(value.data()!);
          final List<ProductModel> products = [];
          await FirebaseFirestore.instance
              .collection('products')
              .get()
              .then((value) {
            for (var element in value.docs) {
              final product = ProductModel.fromJson(element.data());
              if (!product.isDeleted && user.whishlist.contains(product.id)) {
                products.add(product);
              }
            }
            emit(
                WhishlistState(products: products, productIds: user.whishlist));
          });
        }
      });
    });
    on<ChnageWhishListOption>((event, emit) async {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((value) async {
        final user = UserModel.fromJson(value.data()!);
        if (user.whishlist.contains(event.productId)) {
          user.whishlist.remove(event.productId);
        } else {
          user.whishlist.add(event.productId);
        }
        final List<ProductModel> products = [];
        await FirebaseFirestore.instance
            .collection('products')
            .get()
            .then((value) {
          for (var element in value.docs) {
            final product = ProductModel.fromJson(element.data());
            if (!product.isDeleted && user.whishlist.contains(product.id)) {
              products.add(product);
            }
          }
          FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update(user.toJson());
          emit(WhishlistState(products: products, productIds: user.whishlist));
        });
      });
    });
  }
}
