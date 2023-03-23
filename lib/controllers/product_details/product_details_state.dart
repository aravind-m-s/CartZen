part of 'product_details_bloc.dart';

class ProductDetailsState {
  final int color;
  final int size;
  final int image;
  ProductDetailsState({this.color = 0, this.size = 0, this.image = 0});
}

class ProductDetailsInitial extends ProductDetailsState {}
