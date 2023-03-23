part of 'address_bloc.dart';

class AddressState {
  final List address;
  AddressState({required this.address});
}

class AddressInitial extends AddressState {
  AddressInitial() : super(address: []);
}
