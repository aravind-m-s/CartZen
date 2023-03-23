part of 'search_bloc.dart';

class SearchState {
  final List<ProductModel> products;
  SearchState({required this.products});
}

class SearchInitial extends SearchState {
  SearchInitial() : super(products: []);
}
