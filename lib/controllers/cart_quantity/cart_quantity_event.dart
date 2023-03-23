part of 'cart_quantity_bloc.dart';

@immutable
abstract class CartQuantityEvent {}

class UpdaateQuantitiy extends CartQuantityEvent {
  final List<int> quantities;
  final List<dynamic> fullProducts;
  UpdaateQuantitiy({required this.quantities, this.fullProducts = const []});
}
