import 'dart:developer';

import 'package:cartzen/controllers/order/order_bloc.dart';
import 'package:cartzen/models/order_model.dart';
import 'package:cartzen/views/order_details/screen_order_details.dart';
import 'package:cartzen/views/orders/widgets/app_bar.dart';
import 'package:cartzen/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenOrder extends StatelessWidget {
  const ScreenOrder({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<OrderBloc>(context).add(GetAllOrders());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 141),
        child: CurvedAppBar(),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return ListView.separated(
              itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ScreenOrderDetails(
                        order: state.orders[index],
                        products: state.products,
                      ),
                    ));
                  },
                  child: OrderCard(order: state.orders[index])),
              separatorBuilder: (context, index) => kHeight,
              itemCount: state.orders.length);
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({Key? key, required this.order}) : super(key: key);
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final date = order.date;
    final String formattedDate =
        '${date.substring(5, 7)}-${date.substring(8, 10)}-${date.substring(0, 4)}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: padding * 2),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: themeColor),
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderID(id: order.id),
              OrderDetailsCard(title: "Ordered on:", value: formattedDate),
              OrderDetailsCard(
                  title: "No of Products:",
                  value: order.products.length.toString()),
              OrderDetailsCard(
                  title: "PaymentMethod", value: order.paymentMethod),
              OrderDetailsCard(title: "Order Status", value: order.status),
              OrderDetailsCard(
                  title: "Total Amount:", value: order.total.toString()),
              ChangeStatusButton(order: order),
              kHeight10,
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeStatusButton extends StatelessWidget {
  const ChangeStatusButton({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return order.status == "Canceled" ||
            order.status == "Returned" ||
            order.status == "Return Pending"
        ? const SizedBox()
        : Center(
            child: SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                onPressed: () async {
                  if (order.status != 'Delivered' &&
                      order.status != 'Returned') {
                    BlocProvider.of<OrderBloc>(context)
                        .add(CancelOrder(id: order.id));
                  } else if (order.status == "Delivered") {
                    BlocProvider.of<OrderBloc>(context)
                        .add(ReturnOrder(id: order.id));
                  }
                  await Future.delayed(const Duration(seconds: 5)).then(
                      (value) => BlocProvider.of<OrderBloc>(context)
                          .add(GetAllOrders()));
                },
                child: order.status == "Delivered"
                    ? const Text('Return')
                    : const Text("Cancel"),
              ),
            ),
          );
  }
}

class OrderDetailsCard extends StatelessWidget {
  const OrderDetailsCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
        ),
      ],
    );
  }
}

class OrderID extends StatelessWidget {
  const OrderID({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Id: $id",
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: themeColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
