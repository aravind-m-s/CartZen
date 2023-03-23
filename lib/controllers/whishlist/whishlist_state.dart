part of 'whishlist_bloc.dart';

class WhishlistState {
  final List products;
  final List productIds;
  WhishlistState({required this.products, required this.productIds});
}

class WhishlistInitial extends WhishlistState {
  WhishlistInitial() : super(products: const [], productIds: []);
}
