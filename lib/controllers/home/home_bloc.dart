import 'package:bloc/bloc.dart';
import 'package:cartzen/models/product_model.dart';
import 'package:cartzen/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetAllProducts>((event, emit) async {
      List<ProductModel> products = [];

      await FirebaseFirestore.instance
          .collection('products')
          .get()
          .then((value) {
        for (var element in value.docs) {
          final product = ProductModel.fromJson(element.data());
          if (!product.isDeleted) {
            products.add(product);
          }
        }
      });
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          if (value.data() != null) {
            final List<ProductModel> recents = [];
            final user = UserModel.fromJson(value.data()!);
            products.forEach((element) {
              if (user.recents.contains(element.id)) {
                recents.add(element);
              }
            });
            emit(HomeState(
                products: products, recentProducts: recents.reversed.toList()));
          }
        });
      } else {
        emit(HomeState(products: products, recentProducts: []));
      }
    });
  }
}
