part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class GetAllCategory extends CategoryEvent {}

class GetCategoryProducts extends CategoryEvent {
  final String category;
  GetCategoryProducts({required this.category});
}
