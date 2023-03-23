import 'package:bloc/bloc.dart';
import 'package:cartzen/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'cart_quantity_event.dart';
part 'cart_quantity_state.dart';

class CartQuantityBloc extends Bloc<CartQuantityEvent, CartQuantityState> {
  CartQuantityBloc() : super(CartQuantityInitial()) {
    on<UpdaateQuantitiy>((event, emit) async {
      if (event.fullProducts.isNotEmpty) {
        final uid = FirebaseAuth.instance.currentUser!.uid;
        final doc = FirebaseFirestore.instance.collection('cart').doc(uid);
        final fullProducts = event.fullProducts;
        for (int i = 0; i < fullProducts.length; i++) {
          fullProducts[i]['quantity'] = event.quantities[i];
        }
        final CartModel cart = CartModel(id: uid, products: fullProducts);
        doc.update(cart.toJson());
      }
      emit(CartQuantityState(
        quantities: event.quantities,
      ));
    });
  }
}
