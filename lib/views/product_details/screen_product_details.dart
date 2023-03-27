import 'package:cartzen/controllers/whishlist/whishlist_bloc.dart';
import 'package:cartzen/models/cart_model.dart';
import 'package:cartzen/models/product_model.dart';
import 'package:cartzen/views/login/screen_login.dart';
import 'package:cartzen/views/common/default_back_button.dart';
import 'package:cartzen/controllers/cart/cart_bloc.dart';
import 'package:cartzen/controllers/product_details/product_details_bloc.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/views/common/snacbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final TextEditingController _quantity = TextEditingController();
int _selectedColorIndex = 0;
int _selectedSizeIndex = 0;

class ScreenProductDetails extends StatelessWidget {
  const ScreenProductDetails({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProductDetailsBloc>(context)
        .add(AddToRecent(pid: currentProduct!.id));
    WidgetsBinding.instance.addPostFrameCallback((_) => _quantity.text = '1');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(padding),
            child: ListView(
              children: [
                kHeight,
                ProductImages(product: currentProduct!),
                kHeight,
                NameAndPrice(product: currentProduct!),
                Text(currentProduct!.category,
                    style: Theme.of(context).textTheme.titleSmall),
                kHeight,
                ProductDescription(product: currentProduct!),
                kHeight10,
                ColorSection(product: currentProduct!),
                kHeight10,
                SizeSection(product: currentProduct!),
                kHeight10,
                const Divider(color: Colors.black, height: 5),
                kHeight,
                AddingToCartSection(
                  product: currentProduct!,
                ),
              ],
            ),
          ),
          const DefaultBackButton(),
          Positioned(
              top: 32,
              right: 16,
              child: BlocBuilder<WhishlistBloc, WhishlistState>(
                builder: (context, state) {
                  return IconButton(
                    icon: state.productIds.contains(currentProduct!.id)
                        ? const Icon(
                            Icons.favorite,
                            size: 32,
                          )
                        : const Icon(
                            Icons.favorite_outline,
                            size: 32,
                          ),
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser == null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ScreenLogin(),
                        ));
                      } else {
                        BlocProvider.of<WhishlistBloc>(context).add(
                            ChnageWhishListOption(
                                productId: currentProduct!.id));
                      }
                    },
                  );
                },
              ))
        ],
      ),
    );
  }
}

class ProductImages extends StatelessWidget {
  const ProductImages({Key? key, required this.product}) : super(key: key);
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainImage(product: product),
        kHeight,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MiniImage(product: product, index: 0),
            MiniImage(product: product, index: 1),
            MiniImage(product: product, index: 2),
            MiniImage(product: product, index: 3),
          ],
        ),
      ],
    );
  }
}

class MiniImage extends StatelessWidget {
  const MiniImage({
    super.key,
    required this.product,
    required this.index,
  });

  final ProductModel product;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ProductDetailsBloc>(context)
            .add(ChangeImage(index: index));
      },
      child: Container(
        height: 125,
        width: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultRadius),
          image: DecorationImage(
            image: NetworkImage(
              product.images[index],
            ),
          ),
        ),
      ),
    );
  }
}

class MainImage extends StatelessWidget {
  const MainImage({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        return Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultRadius),
            // color: themeColor,
            image: DecorationImage(
              image: NetworkImage(
                product.images[state.image],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProductDescription extends StatelessWidget {
  const ProductDescription({Key? key, required this.product}) : super(key: key);
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Text(
      product.description,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class AddingToCartSection extends StatelessWidget {
  const AddingToCartSection({
    Key? key,
    required this.product,
  }) : super(key: key);
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: const [
            QuantityButton(isDecrease: true),
            CurrentQuantity(),
            QuantityButton(isDecrease: false),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(defaultRadius),
          child: SizedBox(
            width: 150,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: themeColor),
              child: const Text("Add to Cart"),
              onPressed: () async {
                if (FirebaseAuth.instance.currentUser == null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const ScreenLogin(),
                    ),
                  );
                } else {
                  final CartProductModel pdt = CartProductModel(
                      color: product.colors[_selectedColorIndex],
                      productId: product.id,
                      size: product.sizes[_selectedSizeIndex],
                      quantity: int.parse(_quantity.text));
                  BlocProvider.of<CartBloc>(context)
                      .add(AddToCart(product: pdt.toJson()));
                  BlocProvider.of<CartBloc>(context)
                      .add(DecreaseQuantity(count: 2));
                  _quantity.text = '1';
                  showSuccessSnacbar(context, 'Item added to Cart succesfully');
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CurrentQuantity extends StatelessWidget {
  const CurrentQuantity({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(
          color: themeColor,
        ),
      ),
      child: Center(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            _quantity.text = state.count.toString();
            return TextField(
              textAlign: TextAlign.center,
              readOnly: true,
              controller: _quantity,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
            );
          },
        ),
      ),
    );
  }
}

class QuantityButton extends StatelessWidget {
  const QuantityButton({
    super.key,
    required this.isDecrease,
  });

  final bool isDecrease;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isDecrease) {
          BlocProvider.of<CartBloc>(context).add(
            DecreaseQuantity(
              count: int.parse(_quantity.text),
            ),
          );
        } else {
          BlocProvider.of<CartBloc>(context).add(
            IncreaseQuantity(
              count: int.parse(_quantity.text),
            ),
          );
        }
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: themeColor),
          color: Colors.grey.shade400,
        ),
        child: Center(child: Icon(isDecrease ? Icons.remove : Icons.add)),
      ),
    );
  }
}

class SizeSection extends StatelessWidget {
  const SizeSection({
    Key? key,
    required this.product,
  }) : super(key: key);
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sizes",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).textTheme.titleLarge!.color,
                fontWeight: FontWeight.bold,
              ),
        ),
        kHeight10,
        Row(
          children: List.generate(
            product.sizes.length,
            (index) => Row(
              children: [
                InkWell(
                  onTap: () {
                    _selectedSizeIndex = index;
                    BlocProvider.of<ProductDetailsBloc>(context)
                        .add(ChangeSize(index: index));
                  },
                  child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                    builder: (context, state) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: index == state.size
                              ? themeColor
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            product.sizes[index],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: index == state.size
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .color,
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                kWidth10,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ColorSection extends StatelessWidget {
  const ColorSection({
    Key? key,
    required this.product,
  }) : super(key: key);
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Colors: ",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).textTheme.titleLarge!.color,
                fontWeight: FontWeight.bold,
              ),
        ),
        kHeight10,
        Row(
            children: List.generate(
          product.colors.length,
          (index) => Row(
            children: [
              BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      _selectedColorIndex = index;
                      BlocProvider.of<ProductDetailsBloc>(context)
                          .add(ChangeColor(index: index));
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      // radius: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: index == state.color
                            ? Border.all(width: 3, color: themeColor)
                            : null,
                        color: Color(
                          int.parse(
                            product.colors[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              kWidth10,
            ],
          ),
        )),
      ],
    );
  }
}

class NameAndPrice extends StatelessWidget {
  const NameAndPrice({Key? key, required this.product}) : super(key: key);
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    int discountedPrice = 0;
    if (product.isPercent) {
      discountedPrice = product.price * (100 - product.offer) ~/ 100;
    } else {
      discountedPrice = product.price - product.offer;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        product.offer == 0
            ? Text.rich(
                TextSpan(
                    text: "₹",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: themeColor),
                    children: [
                      TextSpan(
                        text: product.price.toString(),
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    ]),
              )
            : Row(
                children: [
                  Text.rich(
                    TextSpan(
                        text: "₹",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: themeColor),
                        children: [
                          TextSpan(
                            text: discountedPrice.toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ]),
                  ),
                  kWidth10,
                  Text.rich(
                    TextSpan(
                      text: "₹",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: themeColor),
                      children: [
                        TextSpan(
                          text: product.price.toString(),
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: themeColor,
                                    decorationThickness: 2,
                                  ),
                        )
                      ],
                    ),
                  ),
                  kWidth10,
                  Container(
                    width: 90,
                    color: themeColor,
                    child: Center(
                      child: Text(
                        product.isPercent
                            ? '${product.offer}% off'
                            : '${product.offer}₹ off',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                      ),
                    ),
                  ),
                ],
              )
      ],
    );
  }
}
