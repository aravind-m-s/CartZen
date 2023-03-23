part of 'cart_bloc.dart';

class CartState {
  final List cartItems;
  final int count;
  final List<ProductModel> fullProduct;
  final String id;
  final List<int> quantities;
  CartState({
    required this.cartItems,
    this.count = 1,
    this.id = '',
    required this.fullProduct,
    required this.quantities,
  });
}

class CartInitial extends CartState {
  CartInitial() : super(cartItems: const [], fullProduct: [], quantities: []);
}
