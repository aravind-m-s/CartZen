part of 'order_bloc.dart';

@immutable
abstract class OrderEvent {}

class Order extends OrderEvent {
  final OrderModel order;
  Order({required this.order});
}

class GetAllOrders extends OrderEvent {}

class CancelOrder extends OrderEvent {
  final String id;
  CancelOrder({required this.id});
}

class ReturnOrder extends OrderEvent {
  final String id;
  ReturnOrder({required this.id});
}
