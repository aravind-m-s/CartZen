part of 'home_bloc.dart';

class HomeState {
  final List<ProductModel> products;
  final List<ProductModel> recentProducts;
  HomeState({required this.products, required this.recentProducts});
}

class HomeInitial extends HomeState {
  HomeInitial({super.products = const [], super.recentProducts = const []});
}
