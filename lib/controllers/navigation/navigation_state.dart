part of 'navigation_bloc.dart';

class NavigationState {
  final Map<String, dynamic> product;
  final int pageIndex;
  const NavigationState({this.product = const {}, required this.pageIndex});
}

class NavigationInitial extends NavigationState {
  NavigationInitial() : super(pageIndex: 0);
}
