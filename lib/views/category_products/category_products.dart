import 'package:cartzen/controllers/category/category_bloc.dart';
import 'package:cartzen/controllers/whishlist/whishlist_bloc.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/models/product_model.dart';
import 'package:cartzen/views/login/screen_login.dart';
import 'package:cartzen/views/product_details/screen_product_details.dart';
import 'package:cartzen/views/select_address/screen_select_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenCategoryProducts extends StatelessWidget {
  const ScreenCategoryProducts({super.key, required this.category});
  final String category;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CategoryBloc>(context)
        .add(GetCategoryProducts(category: category));
    return Scaffold(
      appBar: appBar(),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.60,
              ),
              itemBuilder: (context, index) {
                final cp = state.products[index];
                int discountedPrice = 0;
                if (cp.isPercent) {
                  discountedPrice = cp.price * (100 - cp.offer) ~/ 100;
                } else {
                  discountedPrice = cp.price - cp.offer;
                }
                return ProductCard(
                  cp: cp,
                  products: state.products,
                  discountedPrice: discountedPrice,
                  index: index,
                );
              },
              itemCount: state.products.length);
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.cp,
    required this.products,
    required this.discountedPrice,
    required this.index,
  });

  final ProductModel cp;
  final List<ProductModel> products;
  final int discountedPrice;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        currentProduct = cp;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ScreenProductDetails(),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 125,
                  height: 175,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(defaultRadius),
                    // color: themeColor,
                    image: DecorationImage(
                      image: NetworkImage(
                        products[index].images[0],
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: BlocBuilder<WhishlistBloc, WhishlistState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: Icon(
                          state.productIds.contains(products[index].id)
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          size: 30,
                          color: themeColor,
                        ),
                        onPressed: () {
                          if (FirebaseAuth.instance.currentUser == null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ScreenLogin(),
                              ),
                            );
                          } else {
                            BlocProvider.of<WhishlistBloc>(context).add(
                              ChnageWhishListOption(
                                productId: products[index].id,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kHeight10,
                cp.offer != 0
                    ? Container(
                        width: 90,
                        color: themeColor,
                        child: Center(
                          child: Text(
                            cp.isPercent
                                ? '${cp.offer}% off'
                                : '${cp.offer}₹ off',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Text(
                  cp.name,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                cp.offer != 0
                    ? Row(
                        children: [
                          Text(
                            '₹ $discountedPrice',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 16,
                                ),
                          ),
                          kWidth10,
                          Text(
                            '₹ ${cp.price}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontSize: 16,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: themeColor),
                          ),
                        ],
                      )
                    : Text(
                        '₹ ${cp.price}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

PreferredSize appBar() {
  return PreferredSize(
    preferredSize: const Size(double.infinity, 120),
    child: ClipPath(
      clipper: CustomAppBar(),
      child: AppBar(
        backgroundColor: themeColor,
        title: const Text('Category'),
      ),
    ),
  );
}
