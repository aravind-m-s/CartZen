part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {}

class ChnangePage extends NavigationEvent {
  final int pageIndex;
  final ProductModel? product;
  ChnangePage({this.product, required this.pageIndex});
}
