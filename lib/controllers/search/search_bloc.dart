import 'package:bloc/bloc.dart';
import 'package:cartzen/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchProducts>((event, emit) async {
      await FirebaseFirestore.instance
          .collection('products')
          .get()
          .then((value) {
        final List<ProductModel> allProducts = [];
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            allProducts.add(ProductModel.fromJson(element.data()));
          }
          final List<ProductModel> searchedProducts = [];
          for (var product in allProducts) {
            if (!product.isDeleted) {
              for (var keyword in product.keywords) {
                if (keyword.toLowerCase().contains(event.query) ||
                    product.name.toLowerCase().contains(event.query) ||
                    product.category.toLowerCase().contains(event.query)) {
                  searchedProducts.add(product);
                  break;
                }
              }
            }
          }
          emit(SearchState(products: searchedProducts));
        }
      });
    });
    on<GetAllProducts>((event, emit) async {
      List<ProductModel> products = [];
      await FirebaseFirestore.instance
          .collection('products')
          .get()
          .then((value) {
        for (var element in value.docs) {
          final product = ProductModel.fromJson(element.data());
          if (!product.isDeleted) {
            products.add(product);
          }
        }
      });
      emit(SearchState(products: products));
    });
  }
}
