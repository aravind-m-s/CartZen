import 'package:cartzen/controllers/whishlist/whishlist_bloc.dart';
import 'package:cartzen/models/product_model.dart';
import 'package:cartzen/views/product_details/screen_product_details.dart';
import 'package:cartzen/views/whishlist/widgets/app_bar.dart';
import 'package:cartzen/core/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenWhishlist extends StatelessWidget {
  const ScreenWhishlist({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser != null) {
        BlocProvider.of<WhishlistBloc>(context).add(GetAllWishListProducts());
      }
    });
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 125),
        child: CurvedAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Products',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            kHeight,
            Expanded(
              child: BlocBuilder<WhishlistBloc, WhishlistState>(
                builder: (context, state) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: Text(
                        "No products Added yet",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    );
                  }
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ProductCard(product: product);
                    },
                    separatorBuilder: (context, index) => kHeight,
                    itemCount: state.products.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        currentProduct = product;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ScreenProductDetails()));
      },
      child: Row(
        children: [
          kWidth20,
          ImageWidget(
            image: product.images[0],
          ),
          kWidth10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductName(
                name: product.name,
              ),
              Total(
                price: product.price,
              ),
              StatusSection(
                quantity: product.stock,
                id: product.id,
              )
            ],
          )
        ],
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: 125,
      decoration: BoxDecoration(
          color: themeColor,
          border: Border.all(),
          borderRadius: BorderRadius.circular(defaultRadius),
          image:
              DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
    );
  }
}

class StatusSection extends StatelessWidget {
  const StatusSection({
    Key? key,
    required this.quantity,
    required this.id,
  }) : super(key: key);

  final int quantity;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: quantity != 0 ? Colors.green : Colors.red,
            ),
            kWidth10,
            Text(
              quantity != 0 ? "In Stock" : "Out of Stock",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.green),
            )
          ],
        ),
        const SizedBox(
          width: 50,
        ),
        IconButton(
            onPressed: () {
              BlocProvider.of<WhishlistBloc>(context)
                  .add(ChnageWhishListOption(productId: id));
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ))
      ],
    );
  }
}

class Total extends StatelessWidget {
  const Total({
    Key? key,
    required this.price,
  }) : super(key: key);
  final int price;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
          text: "Price:   ",
          style: Theme.of(context).textTheme.bodyLarge,
          children: [
            TextSpan(
              text: "₹",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: themeColor),
              children: [
                TextSpan(
                  text: "$price",
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
          ]),
    );
  }
}

class ProductName extends StatelessWidget {
  const ProductName({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
