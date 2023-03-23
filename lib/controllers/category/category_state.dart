part of 'category_bloc.dart';

class CategoryState {
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  CategoryState({required this.categories, this.products = const []});
}

class CategoryInitial extends CategoryState {
  CategoryInitial() : super(categories: []);
}
