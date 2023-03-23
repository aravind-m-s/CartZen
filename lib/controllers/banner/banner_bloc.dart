import 'package:bloc/bloc.dart';
import 'package:cartzen/models/banner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  BannerBloc() : super(BannerInitial()) {
    on<GetAllBanners>((event, emit) async {
      await FirebaseFirestore.instance
          .collection('banners')
          .get()
          .then((value) {
        final List<BannerModel> banners = [];
        value.docs.forEach((element) {
          banners.add(BannerModel.fromJson(element.data()));
        });
        emit(BannerState(banners: banners));
      });
    });
  }
}
