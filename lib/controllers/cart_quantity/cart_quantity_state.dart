part of 'cart_quantity_bloc.dart';

class CartQuantityState {
  final List<int> quantities;
  CartQuantityState({required this.quantities});
}

class CartQuantityInitial extends CartQuantityState {
  CartQuantityInitial() : super(quantities: []);
}
