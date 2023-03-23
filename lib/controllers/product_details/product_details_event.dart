part of 'product_details_bloc.dart';

@immutable
abstract class ProductDetailsEvent {}

class ChangeColor extends ProductDetailsEvent {
  final int index;
  ChangeColor({required this.index});
}

class ChangeSize extends ProductDetailsEvent {
  final int index;
  ChangeSize({required this.index});
}

class ChangeImage extends ProductDetailsEvent {
  final int index;
  ChangeImage({required this.index});
}

class AddToRecent extends ProductDetailsEvent {
  final String pid;
  AddToRecent({required this.pid});
}
