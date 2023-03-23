import 'dart:developer';
import 'package:cartzen/controllers/banner/banner_bloc.dart';
import 'package:cartzen/controllers/category/category_bloc.dart';
import 'package:cartzen/controllers/whishlist/whishlist_bloc.dart';
import 'package:cartzen/models/product_model.dart';
import 'package:cartzen/views/Login/screen_login.dart';
import 'package:cartzen/views/categories/screen_categories.dart';
import 'package:cartzen/views/home/wdigets/app_bar.dart';
import 'package:cartzen/controllers/home/home_bloc.dart';
import 'package:cartzen/controllers/navigation/navigation_bloc.dart';
import 'package:cartzen/controllers/theme/theme_bloc.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/views/product_details/screen_product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<HomeBloc>(context).add(
        GetAllProducts(),
      );
      BlocProvider.of<BannerBloc>(context).add(
        GetAllBanners(),
      );
      BlocProvider.of<CategoryBloc>(context).add(GetAllCategory());
    });
    return Scaffold(
      // appBar: AppBar(),

      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 120),
        child: CurvedAppBar(),
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.products.isEmpty) {
              return Center(
                child: Text(
                  "No Products or offers",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            }
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const Titles(title: "Todays deals"),
                      kHeight,
                      const Banners(),
                      kHeight,
                      const CategoriesCard(),
                      const Titles(title: "Top Collections"),
                      kHeight,
                    ],
                  ),
                ),
                // Products(products: state.products),
                Products(products: state.products),
                RecentlyViewed(recentProducts: state.recentProducts),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CategoriesCard extends StatelessWidget {
  const CategoriesCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        int length = 0;
        if (state.categories.length > 3) {
          length = 4;
        } else {
          length = state.categories.length;
        }
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
                length,
                (index) => CategoyItem(
                      category: state.categories[index].category,
                    )));
      },
    );
  }
}

class CategoyItem extends StatelessWidget {
  const CategoyItem({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ScreenCategories(),
      )),
      child: Container(
          width: 75,
          height: 25,
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(defaultRadius)),
          child: Center(
            child: Text(
              category,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          )),
    );
  }
}

class RecentlyViewed extends StatelessWidget {
  const RecentlyViewed({Key? key, required this.recentProducts})
      : super(key: key);

  final List<ProductModel> recentProducts;

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      const Titles(title: "Recently Viewed"),
      LimitedBox(
        maxHeight: 225,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  currentProduct = recentProducts[index];
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScreenProductDetails(),
                  ));
                },
                child: Column(
                  children: [
                    Container(
                      height: 175,
                      width: 125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultRadius),
                        color: themeColor,
                        image: DecorationImage(
                          image: NetworkImage(
                            recentProducts[index].images[0],
                          ),
                        ),
                      ),
                    ),
                    Text(
                      recentProducts[index].name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '₹${recentProducts[index].price}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => kWidth20,
            itemCount: recentProducts.length),
      )
    ]));
  }
}

class Products extends StatelessWidget {
  const Products({Key? key, required this.products}) : super(key: key);
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildListDelegate(
        List.generate(products.length, (index) {
          final cp = products[index];
          int discountedPrice = 0;
          if (cp.isPercent) {
            discountedPrice = cp.price * (100 - cp.offer) ~/ 100;
          } else {
            discountedPrice = cp.price - cp.offer;
          }
          return ProductCard(
            cp: cp,
            products: products,
            discountedPrice: discountedPrice,
            index: index,
          );
        }),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.60,
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
        BlocProvider.of<NavigationBloc>(context).add(
          ChnangePage(
            pageIndex: productDetailsIndex,
            product: currentProduct,
          ),
        );
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

class Banners extends StatelessWidget {
  const Banners({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 100,
      child: BlocBuilder<BannerBloc, BannerState>(
        builder: (context, state) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultRadius),
                    color: themeColor,
                    border: Border.all(),
                    image: DecorationImage(
                        image: NetworkImage(state.banners[index].image),
                        fit: BoxFit.cover)),
              );
            },
            itemCount: state.banners.length,
            separatorBuilder: (context, index) => kWidth20,
          );
        },
      ),
    );
  }
}

class Titles extends StatelessWidget {
  const Titles({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Give a Feedback',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20),
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () {},
              child: Text(
                'Privacy policy',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20),
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () {},
              child: Text(
                'Terms and conditions',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20),
              ),
            ),
            const Divider(),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Dark theme',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 20),
                  ),
                ),
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    return Switch(
                      value: state.darkTheme ?? false,
                      onChanged: (value) {
                        BlocProvider.of<ThemeBloc>(context)
                            .add(ChangeTheme(value: value));
                      },
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            FirebaseAuth.instance.currentUser == null
                ? Builder(builder: (ctx) {
                    return Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          color: themeColor,
                        ),
                        TextButton(
                          onPressed: () async {
                            Scaffold.of(ctx).closeDrawer();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ScreenLogin();
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Login",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 20),
                          ),
                        )
                      ],
                    );
                  })
                : Builder(builder: (ctx) {
                    return Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          color: themeColor,
                        ),
                        TextButton(
                          onPressed: () async {
                            Scaffold.of(ctx).closeDrawer();

                            await FirebaseAuth.instance.signOut().then(
                                  (value) => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const ScreenLogin(),
                                    ),
                                  ),
                                );
                          },
                          child: Text(
                            "Logout",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 20),
                          ),
                        )
                      ],
                    );
                  })
          ],
        ),
      ),
    );
  }
}
