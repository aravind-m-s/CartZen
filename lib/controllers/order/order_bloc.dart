import 'package:bloc/bloc.dart';
import 'package:cartzen/models/order_model.dart';
import 'package:cartzen/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<Order>((event, emit) async {
      final doc = FirebaseFirestore.instance.collection('orders').doc();
      final OrderModel order = OrderModel(
        products: event.order.products,
        uid: event.order.uid,
        id: doc.id,
        status: event.order.status,
        date: event.order.date,
        paymentMethod: event.order.paymentMethod,
        coupon: event.order.coupon,
        total: event.order.total,
        address: event.order.address,
      );
      await doc.set(order.toJson());
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(event.order.uid)
          .update({'id': event.order.uid, 'products': []});
    });
    on<GetAllOrders>((event, emit) async {
      await FirebaseFirestore.instance
          .collection('orders')
          .get()
          .then((value) async {
        final List<OrderModel> orders = [];
        for (var element in value.docs) {
          orders.add(OrderModel.fromJson(element.data()));
        }
        final List<OrderModel> userOrders = orders
            .where((element) =>
                element.uid == FirebaseAuth.instance.currentUser!.uid)
            .toList();
        await FirebaseFirestore.instance
            .collection('products')
            .get()
            .then((value) async {
          final List<ProductModel> products = [];
          for (var element in value.docs) {
            products.add(ProductModel.fromJson(element.data()));
          }
          emit(OrderState(orders: userOrders, products: products));
        });
      });
    });
    on<CancelOrder>((event, emit) async {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(event.id)
          .get()
          .then((value) async {
        if (value.data() != null) {
          final data = value.data();
          data!['status'] = 'Canceled';
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(event.id)
              .update(data);
        }
      });
    });
    on<ReturnOrder>((event, emit) async {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(event.id)
          .get()
          .then((value) async {
        if (value.data() != null) {
          final data = value.data();
          data!['status'] = 'Return Pending';
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(event.id)
              .update(data);
        }
      });
    });
  }
}
