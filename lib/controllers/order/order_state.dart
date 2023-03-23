part of 'order_bloc.dart';

class OrderState {
  final List<OrderModel> orders;
  final List<ProductModel> products;
  OrderState({required this.orders, required this.products});
}

class OrderInitial extends OrderState {
  OrderInitial() : super(orders: [], products: []);
}
