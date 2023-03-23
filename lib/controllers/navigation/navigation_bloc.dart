import 'package:bloc/bloc.dart';
import 'package:cartzen/models/product_model.dart';
import 'package:cartzen/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<ChnangePage>((event, emit) {
      previousIndex = state.pageIndex;
      emit(NavigationState(pageIndex: event.pageIndex));
    });
  }
}
