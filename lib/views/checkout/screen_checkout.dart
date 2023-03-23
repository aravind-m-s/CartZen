import 'dart:convert';
import 'dart:developer';

import 'package:cartzen/controllers/coupon/coupon_bloc.dart';
import 'package:cartzen/controllers/order/order_bloc.dart';
import 'package:cartzen/core/keys.dart';
import 'package:cartzen/models/order_model.dart';
import 'package:cartzen/views/common/custom_clipper.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/views/common/snacbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cartzen/views/orders/screen_orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

final TextEditingController controller = TextEditingController();
int couponTotal = 0;
int couponIndex = 0;
String couponCode = '';

class ScreenCheckout extends StatelessWidget {
  const ScreenCheckout({
    super.key,
    required this.ttl,
    required this.products,
    required this.address,
  });
  final int ttl;
  final List products;
  final Map<String, dynamic> address;

  clear() {
    controller.text = '';
    couponTotal = 0;
  }

  @override
  Widget build(BuildContext context) {
    clear();
    BlocProvider.of<CouponBloc>(context).add(GetAllCoupon());
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding * 2),
        child: ListView(
          children: [
            kHeight,
            AddressSection(
              address: address,
            ),
            kHeight,
            CouponSection(
              total: ttl,
            ),
            BlocBuilder<CouponBloc, CouponState>(
              builder: (context, state) {
                return PriceSection(total: ttl);
              },
            ),
            PaymentMethods(
              total: ttl - couponTotal,
              products: products,
              address: address,
            ),
            kHeight50
          ],
        ),
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
          title: const Text('Checkout'),
        ),
      ),
    );
  }
}

class AddressSection extends StatelessWidget {
  const AddressSection({super.key, required this.address});
  final Map<String, dynamic> address;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '   Delevering To',
                style: TextStyle(
                  color: themeColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AddressText(text: address['name']),
              AddressText(text: address['address']),
              AddressText(text: address['locality']),
              AddressText(text: address['pincode'])
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
    );
  }
}

class AddressText extends StatelessWidget {
  const AddressText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      '   $text',
      style: TextStyle(
        color: Theme.of(context).textTheme.titleLarge!.color,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class PriceSection extends StatelessWidget {
  const PriceSection({
    super.key,
    required this.total,
  });
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        kHeight,
        PriceTextWidget(title: "Total:", price: '$total'),
        PriceTextWidget(title: "Coupon:", price: '$couponTotal'),
        const Divider(color: Colors.black),
        PriceTextWidget(title: "Grand Total:", price: '${total - couponTotal}'),
        const Divider(color: Colors.black),
      ],
    );
  }
}

class PriceTextWidget extends StatelessWidget {
  const PriceTextWidget({
    super.key,
    required this.title,
    required this.price,
  });
  final String price;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        kWidth10,
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Expanded(child: kWidth10),
        Text(
          '₹ $price',
          style: Theme.of(context).textTheme.titleLarge,
        )
      ],
    );
  }
}

class CouponSection extends StatelessWidget {
  const CouponSection({super.key, required this.total});
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: Column(
          children: [
            InputField(controller: controller),
            kHeight,
            ApplyButton(
              total: total,
            ),
          ],
        ),
      ),
    );
  }
}

class ApplyButton extends StatelessWidget {
  const ApplyButton({
    super.key,
    required this.total,
  });
  final int total;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(defaultRadius),
        child: BlocBuilder<CouponBloc, CouponState>(
          builder: (context, state) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
              ),
              onPressed: () {
                final List<String> coupons = [];
                final List<int> offers = [];
                for (var element in state.coupons) {
                  coupons.add(element.couponCode.toUpperCase().trim());
                  offers.add(element.offer);
                }
                ;
                if (!coupons.contains(controller.text.toUpperCase())) {
                  showSuccessSnacbar(context, 'No Coupon Found');
                } else {
                  final coupon = state.coupons[coupons.indexOf(
                    controller.text.toUpperCase().trim(),
                  )];
                  if (DateTime.now().isAfter(DateTime.parse(coupon.endDate))) {
                    showSuccessSnacbar(context, 'Coupon Already Expired');
                  } else if (DateTime.now()
                      .isBefore(DateTime.parse(coupon.startDate))) {
                    showSuccessSnacbar(context, 'Coupon is not yet active');
                  } else if (coupon.redeemedUsers
                      .contains(FirebaseAuth.instance.currentUser!.uid)) {
                    showSuccessSnacbar(context, 'Coupon already redeemed');
                  } else if (coupon.max > total) {
                    showSuccessSnacbar(
                        context, 'Minimun Order should be of ${coupon.max}');
                  } else {
                    couponTotal = coupon.offer;
                    couponIndex = state.coupons.indexOf(coupon);
                    couponCode = coupon.couponCode;
                    BlocProvider.of<CouponBloc>(context)
                        .add(ApplyCoupon(coupon: coupon.couponCode));
                    showSuccessSnacbar(context, 'Coupon applied succefully');
                  }
                }
              },
              child: Text(
                'Apply Coupon',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: darkMode ? Colors.white : Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Coupon cannot be empty";
        } else {
          return null;
        }
      },
      controller: controller,
      cursorColor: themeColor,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: themeColor,
          ),
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(defaultRadius)),
        focusColor: themeColor,
        hintText: 'Coupon',
        labelStyle: const TextStyle(color: themeColor),
        label: const Text('Coupon'),
        alignLabelWithHint: true,
      ),
    );
  }
}

class PaymentMethods extends StatelessWidget {
  const PaymentMethods(
      {super.key,
      required this.total,
      required this.products,
      required this.address});
  final int total;
  final List products;
  final Map<String, dynamic> address;

  @override
  Widget build(BuildContext context) {
    void handlePaymentSuccess(PaymentSuccessResponse response) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final order = OrderModel(
        products: products,
        uid: uid,
        id: '',
        status: "Pending",
        date: DateTime.now().toString(),
        paymentMethod: "RazorPay",
        coupon: couponCode,
        total: (total - couponTotal).toString(),
        address: address,
      );
      BlocProvider.of<OrderBloc>(context).add(Order(order: order));
      showSuccessSnacbar(context, 'Order Placed Succesfully');
      BlocProvider.of<CouponBloc>(context)
          .add(AddUserToCoupon(coupon: couponCode));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ScreenOrder(),
      ));
    }

    void handlePaymentError(PaymentFailureResponse response) {
      showSuccessSnacbar(context, 'Please Try again later');
    }

    void handleExternalWallet(ExternalWalletResponse response) {}

    final razorpay = Razorpay();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    });

    openGateway(String orderId) {
      var option = {
        'key': key_id,
        'amount': (total - couponTotal) * 100,
        'name': 'Order',
        'orderId': orderId,
        'description': 'A simple order',
        'timeout': 60 * 5,
        'prefill': {'contact': '9112121212', 'email': 'aravind@gmail.com'}
      };
      razorpay.open(option);
    }

    createOrder() async {
      final basicAuth =
          'Basic ${base64Encode(utf8.encode('$key_id:$key_secret'))}';
      Map<String, dynamic> body = {
        "amount": (total - couponTotal) * 100,
        "currency": "INR",
        "receipt": "rcptid_11"
      };
      var res = await http.post(
        Uri.https("api.razorpay.com", "v1/orders"),
        headers: {
          "Content-type": "application/json",
          "authorization": basicAuth,
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        openGateway(jsonDecode(res.body)['id']);
      }
      log(res.body);
    }

    return Row(
      children: [
        Column(
          children: [
            Center(
              child: Text(
                'Select Payment Method',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            kHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                COD(
                  products: products,
                  prices: total,
                  address: address,
                ),
                kWidth10,
                InkWell(
                    onTap: () {
                      createOrder();
                    },
                    child: const PaymentOption(title: 'razorpay')),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class PaymentOption extends StatelessWidget {
  const PaymentOption({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(defaultRadius),
          image: const DecorationImage(
              image: AssetImage('assets/razorpay.png'), fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class COD extends StatelessWidget {
  const COD(
      {super.key,
      required this.products,
      required this.prices,
      required this.address});
  final List products;
  final int prices;
  final Map<String, dynamic> address;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            final uid = FirebaseAuth.instance.currentUser!.uid;
            final order = OrderModel(
              products: products,
              uid: uid,
              id: '',
              status: "Pending",
              date: DateTime.now().toString(),
              paymentMethod: "COD",
              coupon: couponCode,
              total: (prices - couponTotal).toString(),
              address: address,
            );
            BlocProvider.of<OrderBloc>(context).add(Order(order: order));
            BlocProvider.of<CouponBloc>(context)
                .add(AddUserToCoupon(coupon: couponCode));
            showSuccessSnacbar(context, 'Order Placed Succesfully');
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const ScreenOrder(),
            ));
          },
          child: Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(defaultRadius),
            ),
            child: Center(
              child: Text(
                'COD',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
