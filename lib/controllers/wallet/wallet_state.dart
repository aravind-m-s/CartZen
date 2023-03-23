part of 'wallet_bloc.dart';

class WalletState {
  final int balance;
  WalletState({required this.balance});
}

class WalletInitial extends WalletState {
  WalletInitial() : super(balance: 0);
}
