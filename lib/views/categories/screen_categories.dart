import 'package:cartzen/controllers/category/category_bloc.dart';
import 'package:cartzen/models/category_model.dart';
import 'package:cartzen/views/category_products/category_products.dart';
import 'package:cartzen/views/common/custom_clipper.dart';
import 'package:cartzen/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenCategories extends StatelessWidget {
  const ScreenCategories({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => BlocProvider.of<CategoryBloc>(context).add(GetAllCategory()));
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          kHeight,
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final CategoryModel category = state.categories[index];
                    return CategoryCard(
                      category: category,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 120),
      child: ClipPath(
        clipper: CustomAppBar(),
        child: AppBar(
          backgroundColor: themeColor,
          title: const Text('Categories'),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
  });
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ScreenCategoryProducts(category: category.category),
        ));
      },
      child: Column(
        children: [
          Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(defaultRadius),
              border: Border.all(),
              image: DecorationImage(
                  image: NetworkImage(category.image), fit: BoxFit.cover),
            ),
          ),
          Text(
            category.category,
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }
}
