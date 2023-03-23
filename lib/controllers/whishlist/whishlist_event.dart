part of 'whishlist_bloc.dart';

@immutable
abstract class WhishlistEvent {}

class GetAllWishListProducts extends WhishlistEvent {}

class ChnageWhishListOption extends WhishlistEvent {
  final String productId;
  ChnageWhishListOption({required this.productId});
}
