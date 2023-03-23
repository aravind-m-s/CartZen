part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class GetAllProducts extends CartEvent {}

class IncreaseQuantity extends CartEvent {
  final int count;
  IncreaseQuantity({required this.count});
}

class DecreaseQuantity extends CartEvent {
  final int count;
  DecreaseQuantity({required this.count});
}

class DeleteFromCart extends CartEvent {
  final Map<String, dynamic> product;
  final List products;
  DeleteFromCart({required this.products, required this.product});
}

class AddToCart extends CartEvent {
  final Map<String, dynamic> product;
  AddToCart({required this.product});
}
