import 'package:cartzen/controllers/navigation/navigation_bloc.dart';
import 'package:cartzen/controllers/search/search_bloc.dart';
import 'package:cartzen/controllers/whishlist/whishlist_bloc.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/models/product_model.dart';
import 'package:cartzen/views/Login/screen_login.dart';
import 'package:cartzen/views/product_details/screen_product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenSearchResult extends StatelessWidget {
  const ScreenSearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<SearchBloc>(context).add(GetAllProducts());
    });
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 120),
        child: CurvedAppBar(),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state.products.isEmpty) {
            return Center(
              child: Text(
                'Please search a valid product',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }
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

class CurvedAppBar extends StatelessWidget {
  const CurvedAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: CustomAppBar(),
        child: AppBar(
            backgroundColor: themeColor,
            title: SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    BlocProvider.of<SearchBloc>(context).add(GetAllProducts());
                  } else {
                    BlocProvider.of<SearchBloc>(context)
                        .add(SearchProducts(query: value));
                  }
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: const TextStyle(fontSize: 14),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(defaultRadius),
                  ),
                ),
              ),
            )));
  }
}

class CustomAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 360;
    final double yScaling = size.height / 141;
    path.lineTo(102.515 * xScaling, 120.478 * yScaling);
    path.cubicTo(
      223.94 * xScaling,
      66.9138 * yScaling,
      322.794 * xScaling,
      103.867 * yScaling,
      360.271 * xScaling,
      126.185 * yScaling,
    );
    path.cubicTo(
      360.271 * xScaling,
      126.185 * yScaling,
      360.271 * xScaling,
      0 * yScaling,
      360.271 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      360.271 * xScaling,
      0 * yScaling,
      -0.0000305176 * xScaling,
      0 * yScaling,
      -0.0000305176 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      -0.0000305176 * xScaling,
      0 * yScaling,
      0 * xScaling,
      138.819 * yScaling,
      0 * xScaling,
      138.819 * yScaling,
    );
    path.cubicTo(
      23.2431 * xScaling,
      143.967 * yScaling,
      56.3983 * xScaling,
      140.822 * yScaling,
      102.515 * xScaling,
      120.478 * yScaling,
    );
    path.cubicTo(
      102.515 * xScaling,
      120.478 * yScaling,
      102.515 * xScaling,
      120.478 * yScaling,
      102.515 * xScaling,
      120.478 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
