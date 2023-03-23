import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cartzen/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(ProductDetailsInitial()) {
    on<ChangeColor>((event, emit) {
      emit(
        ProductDetailsState(
          size: state.size,
          color: event.index,
          image: state.image,
        ),
      );
    });
    on<ChangeSize>((event, emit) {
      emit(
        ProductDetailsState(
          size: event.index,
          color: state.color,
          image: state.image,
        ),
      );
    });
    on<ChangeImage>((event, emit) {
      emit(
        ProductDetailsState(
          size: state.size,
          color: state.color,
          image: event.index,
        ),
      );
    });
    on<AddToRecent>((event, emit) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .then((value) {
          if (value.data() != null) {
            log('here');
            final user = UserModel.fromJson(value.data()!);
            if (user.recents.contains(event.pid)) {
              user.recents.remove(event.pid);
            }
            if (user.recents.length >= 10) {
              user.recents.removeLast();
            }
            user.recents.add(event.pid);
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.id)
                .update(user.toJson());
          }
        });
      }
    });
  }
}
