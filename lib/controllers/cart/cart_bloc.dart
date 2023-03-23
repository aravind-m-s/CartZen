import 'package:bloc/bloc.dart';
import 'package:cartzen/models/cart_model.dart';
import 'package:cartzen/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'cart_event.dart';
part 'cart_state.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<GetAllProducts>((event, emit) async {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userCart = await FirebaseFirestore.instance
          .collection('cart')
          .doc(
            uid,
          )
          .get()
          .then(
            (value) => value.data(),
          );
      final String id = userCart?['id'] ?? '';
      List cart = userCart?['products'] ?? [{}];
      List<ProductModel> cartProducts = [];
      if (cart.isNotEmpty) {
        List<Map<String, dynamic>> products = [];
        await FirebaseFirestore.instance
            .collection('products')
            .get()
            .then((value) {
          for (var element in value.docs) {
            products.add(element.data());
          }
        });
        for (var product in cart) {
          for (var mainProduct in products) {
            if (product['productId'] == mainProduct['id']) {
              cartProducts.add(ProductModel.fromJson(mainProduct));
            }
          }
        }
      }
      emit(CartState(
          fullProduct: cartProducts,
          cartItems: cart,
          id: id,
          quantities: state.quantities,
          count: state.count));
    });

    on<IncreaseQuantity>((event, emit) {
      int count = event.count;
      if (count < 10) {
        emit(CartState(
            fullProduct: state.fullProduct,
            cartItems: state.cartItems,
            quantities: state.quantities,
            count: ++count));
      }
    });
    on<DecreaseQuantity>((event, emit) {
      int count = event.count;
      if (count > 1) {
        emit(
          CartState(
            fullProduct: state.fullProduct,
            cartItems: state.cartItems,
            quantities: state.quantities,
            count: --count,
          ),
        );
      }
    });
    on<AddToCart>((event, emit) async {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userCart = await FirebaseFirestore.instance
          .collection('cart')
          .doc(
            uid,
          )
          .get()
          .then(
            (value) => value.data(),
          );
      List cart = userCart?['products'] ?? [];
      if (cart.isEmpty) {
        cart.add(event.product);
        final CartModel cartModel = CartModel(id: uid, products: cart);
        FirebaseFirestore.instance
            .collection('cart')
            .doc(uid)
            .set(cartModel.toJson());
      } else {
        bool contains = false;
        for (var element in cart) {
          if (element['productId'] == event.product['productId']) {
            contains = true;
          }
        }
        if (contains) {
          final cartPdts = cart
              .where((element) =>
                  element['productId'] != event.product['productId'])
              .toList();
          final pdt = cart
              .where((element) =>
                  element['productId'] == event.product['productId'])
              .toList();
          if (pdt[0]['color'] == event.product['color'] &&
              pdt[0]['size'] == event.product['size']) {
            pdt[0]['quantity'] = pdt[0]['quantity'] + event.product['quantity'];
            pdt[0]['quantity'] > 10
                ? pdt[0]['quantity'] = 10
                : pdt[0]['quantity'] = pdt[0]['quantity'];
            cartPdts.add(pdt[0]);
            final CartModel cartModel = CartModel(id: uid, products: cartPdts);
            FirebaseFirestore.instance
                .collection('cart')
                .doc(uid)
                .update(cartModel.toJson());
          } else {
            cart.add(event.product);
            final CartModel cartModel = CartModel(id: uid, products: cart);
            FirebaseFirestore.instance
                .collection('cart')
                .doc(uid)
                .set(cartModel.toJson());
          }
        } else {
          cart.add(event.product);
          final CartModel cartModel = CartModel(id: uid, products: cart);
          FirebaseFirestore.instance
              .collection('cart')
              .doc(uid)
              .set(cartModel.toJson());
        }
      }
    });
    on<DeleteFromCart>((event, emit) async {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userCart = FirebaseFirestore.instance.collection('cart').doc(
            uid,
          );
      final cart =
          event.products.where((element) => element != event.product).toList();
      userCart.update(CartModel(id: uid, products: cart).toJson());
    });
  }
}
