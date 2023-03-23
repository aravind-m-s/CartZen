import 'package:bloc/bloc.dart';
import 'package:cartzen/models/category_model.dart';
import 'package:cartzen/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<GetAllCategory>((event, emit) async {
      final doc = await FirebaseFirestore.instance
          .collection('category')
          .get()
          .then((value) => value.docs);
      final List<CategoryModel> categories = [];

      for (var element in doc) {
        final category = CategoryModel.fromJson(element.data());
        if (!category.isDeleted) {
          categories.add(category);
        }
      }
      emit(CategoryState(categories: categories));
    });
    on<GetCategoryProducts>((event, emit) async {
      await FirebaseFirestore.instance
          .collection('products')
          .get()
          .then((value) {
        final List<ProductModel> products = [];
        if (value.docs.isNotEmpty) {
          value.docs.forEach((element) {
            if (element.data()['category'].toLowerCase() ==
                event.category.toLowerCase()) {
              products.add(ProductModel.fromJson(element.data()));
            }
          });

          emit(CategoryState(categories: state.categories, products: products));
        }
      });
    });
  }
}
