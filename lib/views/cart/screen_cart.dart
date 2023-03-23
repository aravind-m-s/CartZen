import 'dart:developer';
import 'package:cartzen/models/product_model.dart';
import 'package:cartzen/views/common/snacbar.dart';
import 'package:cartzen/controllers/cart/cart_bloc.dart';
import 'package:cartzen/controllers/cart_quantity/cart_quantity_bloc.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/views/select_address/screen_select_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenCart extends StatelessWidget {
  const ScreenCart({super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      BlocProvider.of<CartBloc>(context).add(GetAllProducts());
    }
    final List<int> quantities = [];
    final List<int> prices = [];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 120),
        child: ClipPath(
          clipper: CustomAppBar(),
          child: AppBar(
            backgroundColor: themeColor,
            title: const Text('\t\t\tCart'),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state.cartItems.isEmpty) {
                  return Center(
                    child: Text(
                      'Empty',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                }
                prices.clear();
                quantities.clear();
                for (var element in state.cartItems) {
                  quantities.add(element['quantity']);
                }
                for (var element in state.fullProduct) {
                  if (element.offer != 0) {
                    if (element.isPercent) {
                      final int discount =
                          (element.price * element.offer / 100).round();

                      prices.add(element.price - discount);
                    } else {
                      prices.add(element.price - element.offer);
                    }
                  } else {
                    prices.add(element.price);
                  }
                }
                BlocProvider.of<CartQuantityBloc>(context)
                    .add(UpdaateQuantitiy(quantities: quantities));
                return ListView.builder(
                  itemBuilder: (context, index) => ProductCard(
                    index: index,
                    quantities: quantities,
                    prices: prices,
                  ),
                  itemCount: state.cartItems.length,
                );
              },
            ),
          ),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return CheckoutSection(
                prices: prices,
                quantities: quantities,
                products: state.cartItems,
              );
            },
          ),
        ],
      ),
    );
  }
}

class CheckoutSection extends StatelessWidget {
  const CheckoutSection({
    super.key,
    required this.prices,
    required this.products,
    required this.quantities,
  });
  final List<int> prices;
  final List<int> quantities;
  final List products;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(defaultRadius * 2),
          topRight: Radius.circular(defaultRadius * 2),
        ),
        border: Border.all(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(padding * 2),
        child: BlocBuilder<CartQuantityBloc, CartQuantityState>(
          builder: (context, state) {
            final int subTotal = getSubTotal(quantities, prices);
            return Column(
              children: [
                SubTotal(price: subTotal),
                kHeight10,
                const Wallet(),
                kHeight10,
                const Divider(height: 5, color: Colors.black),
                kHeight10,
                CheckOutTotal(price: subTotal),
                kHeight,
                CheckoutButton(
                    quantities: quantities, prices: prices, products: products)
              ],
            );
          },
        ),
      ),
    );
  }
}

getSubTotal(List<int> quantities, List<int> prices) {
  int price = 0;
  for (int i = 0; i < quantities.length; i++) {
    price += prices[i] * quantities[i];
  }
  return price;
}

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({
    super.key,
    required this.quantities,
    required this.prices,
    required this.products,
  });

  final List<int> quantities;
  final List<int> prices;
  final List products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(defaultRadius),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColor,
          ),
          onPressed: () {
            if (getSubTotal(quantities, prices) != 0) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ScreenAddressSelect(
                  total: getSubTotal(quantities, prices),
                  products: products,
                ),
              ));
            } else {
              showSuccessSnacbar(context, "No Items in cart");
            }
          },
          child: Text(
            'Proceed To checkout',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CheckOutTotal extends StatelessWidget {
  const CheckOutTotal({
    Key? key,
    required this.price,
  }) : super(key: key);
  final int price;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Grand Total",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          "₹ $price",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class Wallet extends StatelessWidget {
  const Wallet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Wallet",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          "₹ 0",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class SubTotal extends StatelessWidget {
  const SubTotal({
    Key? key,
    required this.price,
  }) : super(key: key);
  final int price;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Sub Total",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          "₹ $price",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.index,
    required this.quantities,
    required this.prices,
  }) : super(key: key);
  final int index;
  final List<int> quantities;
  final List<int> prices;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final fullProduct = state.fullProduct[index];
        final cartProduct = state.cartItems[index];
        return Row(
          children: [
            kWidth20,
            ImageWidget(
              image: fullProduct.images[0],
            ),
            kWidth20,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductName(
                  name: fullProduct.name,
                ),
                Quantity(
                  quantity: cartProduct['quantity'],
                  price: prices[index],
                  quantities: quantities,
                  index: index,
                  cartProduct: state.cartItems,
                ),
                SizeAndColor(cartProduct: cartProduct),
                Total(price: prices[index], index: index),
                StatusSection(
                  product: cartProduct,
                  allProducts: state.cartItems,
                  fullProduct: fullProduct,
                )
              ],
            )
          ],
        );
      },
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
        borderRadius: BorderRadius.circular(defaultRadius),
        border: Border.all(),
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
      ),
    );
  }
}

class StatusSection extends StatelessWidget {
  const StatusSection({
    Key? key,
    required this.product,
    required this.allProducts,
    required this.fullProduct,
  }) : super(key: key);

  final Map<String, dynamic> product;
  final List allProducts;
  final ProductModel fullProduct;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor:
                  fullProduct.stock == 0 ? Colors.red : Colors.green,
            ),
            kWidth10,
            Text(
              fullProduct.stock == 0 ? "Out of stock" : "In Stock",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: fullProduct.stock == 0 ? Colors.red : Colors.green),
            )
          ],
        ),
        const SizedBox(
          width: 50,
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Are you sure"),
                content: Text(
                  "Do you want to delete this address",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "cancel",
                        style: Theme.of(context).textTheme.titleSmall,
                      )),
                  TextButton(
                      onPressed: () {
                        BlocProvider.of<CartBloc>(context).add(
                          DeleteFromCart(
                            product: product,
                            products: allProducts,
                          ),
                        );
                        BlocProvider.of<CartBloc>(context)
                            .add(GetAllProducts());
                        showSuccessSnacbar(context, 'Item deleted from cart');
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "OK",
                        style: Theme.of(context).textTheme.titleSmall,
                      ))
                ],
              ),
            );
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        )
      ],
    );
  }
}

class Total extends StatelessWidget {
  const Total({
    Key? key,
    required this.price,
    required this.index,
  }) : super(key: key);
  final int price;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartQuantityBloc, CartQuantityState>(
      builder: (context, state) {
        if (state.quantities.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Text.rich(
          TextSpan(
              text: "Total:   ",
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
                      text: (price * state.quantities[index]).toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                  ],
                ),
              ]),
        );
      },
    );
  }
}

class SizeAndColor extends StatelessWidget {
  const SizeAndColor({Key? key, required this.cartProduct}) : super(key: key);
  final dynamic cartProduct;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text.rich(
          TextSpan(
            text: "size: ",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).textTheme.bodySmall!.color),
            children: [
              TextSpan(
                text: cartProduct['size'],
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).textTheme.titleLarge!.color,
                    ),
              ),
            ],
          ),
        ),
        kWidth20,
        Row(
          children: [
            Text(
              "Color: ",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color),
            ),
            CircleAvatar(
              radius: 12,
              backgroundColor: Color(int.parse(cartProduct['color'])),
            ),
          ],
        ),
      ],
    );
  }
}

class Quantity extends StatelessWidget {
  const Quantity({
    Key? key,
    required this.quantity,
    required this.price,
    required this.quantities,
    required this.index,
    required this.cartProduct,
  }) : super(key: key);
  final int quantity;
  final int price;
  final int index;
  final List<int> quantities;
  final List<dynamic> cartProduct;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (quantities[index] > 1) {
              quantities[index] = --quantities[index];
              BlocProvider.of<CartQuantityBloc>(context).add(UpdaateQuantitiy(
                  quantities: quantities, fullProducts: cartProduct));
            } else {
              BlocProvider.of<CartBloc>(context).add(DeleteFromCart(
                  products: cartProduct, product: cartProduct[index]));
              BlocProvider.of<CartBloc>(context).add(GetAllProducts());
              showSuccessSnacbar(context, 'Item deleted from cart');
            }
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.grey.shade400,
            ),
            child: const Center(child: Icon(Icons.remove)),
          ),
        ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(border: Border.all()),
          child: Center(
            child: BlocBuilder<CartQuantityBloc, CartQuantityState>(
              builder: (context, state) {
                if (state.quantities.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Text(
                  state.quantities[index].toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                      ),
                );
              },
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (quantities[index] < 11) {
              int qty = quantities[index] + 1;
              quantities[index] = qty;
              BlocProvider.of<CartQuantityBloc>(context).add(
                UpdaateQuantitiy(
                  quantities: quantities,
                  fullProducts: cartProduct,
                ),
              );
            }
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.grey.shade400,
            ),
            child: const Center(child: Icon(Icons.add)),
          ),
        ),
        const Icon(Icons.close),
        Text.rich(
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
        )
      ],
    );
  }
}

class QuantityButton extends StatelessWidget {
  const QuantityButton({
    super.key,
    this.isIncrease = false,
    required this.count,
  });
  final bool isIncrease;
  final int count;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isIncrease) {
          BlocProvider.of<CartBloc>(context)
              .add(IncreaseQuantity(count: count));
        } else {
          BlocProvider.of<CartBloc>(context)
              .add(DecreaseQuantity(count: count));
        }
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.grey.shade400,
        ),
        child: Center(child: Icon(isIncrease ? Icons.add : Icons.remove)),
      ),
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
