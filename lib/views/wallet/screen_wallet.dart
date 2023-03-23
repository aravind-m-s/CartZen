import 'package:cartzen/controllers/wallet/wallet_bloc.dart';
import 'package:cartzen/views/wallet/widgets/app_bar.dart';
import 'package:cartzen/core/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenWallet extends StatelessWidget {
  const ScreenWallet({super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      BlocProvider.of<WalletBloc>(context).add(GetBalance());
    }
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 200),
          child: CurvedAppBar(),
        ),
        body: Center(
          child: Column(
            children: [
              const Icon(
                Icons.wallet,
                size: 200,
              ),
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  if (FirebaseAuth.instance.currentUser == null) {
                    return Center(
                      child: Text(
                        "Please Sign in First",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    );
                  }
                  return Text(
                    'Balance: ${state.balance}',
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                },
              ),
            ],
          ),
        ));
  }
}
