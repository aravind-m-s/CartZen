import 'package:cartzen/views/cart/screen_cart.dart';
import 'package:cartzen/views/home/screen_home.dart';
import 'package:cartzen/views/orders/screen_orders.dart';
import 'package:cartzen/views/product_details/screen_product_details.dart';
import 'package:cartzen/views/profile/screen_profile.dart';
import 'package:cartzen/views/user_detials/screen_user_details.dart';
import 'package:cartzen/views/wallet/screen_wallet.dart';
import 'package:cartzen/views/whishlist/screen_whishlist.dart';
import 'package:cartzen/controllers/navigation/navigation_bloc.dart';
import 'package:cartzen/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenMain extends StatelessWidget {
  const ScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          List<Widget> pages = [
            const ScreenHome(),
            const ScreenWallet(),
            const ScreenWhishlist(),
            const ScreenProfile(),
            const ScreenCart(),
            const ScreenProductDetails(),
            const ScreenUserDetails(),
            const ScreenOrder(),
          ];
          return pages[state.pageIndex];
        },
      ),
      bottomNavigationBar: const DefaultBottomSheet(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const DefaultCartButton(),
    );
  }
}

class DefaultCartButton extends StatelessWidget {
  const DefaultCartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        BlocProvider.of<NavigationBloc>(context)
            .add(ChnangePage(pageIndex: cartIndex));
      },
      child: const Icon(Icons.shopping_cart, color: Colors.white),
    );
  }
}

class DefaultBottomSheet extends StatelessWidget {
  const DefaultBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 100,
      shape: const CircularNotchedRectangle(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomButton(
                  index: homeIndex,
                  currentIndex: state.pageIndex,
                  icon: Icons.home),
              BottomButton(
                  index: walletIndex,
                  currentIndex: state.pageIndex,
                  icon: Icons.account_balance_wallet_rounded),
              kWidth20,
              BottomButton(
                  index: whishlistIndex,
                  currentIndex: state.pageIndex,
                  icon: Icons.favorite),
              BottomButton(
                  index: profileIndex,
                  currentIndex: state.pageIndex,
                  icon: Icons.person),
            ],
          );
        },
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({
    Key? key,
    required this.index,
    required this.currentIndex,
    required this.icon,
  }) : super(key: key);
  final int index;
  final int currentIndex;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: currentIndex == index
            ? themeColor
            : Theme.of(context).textTheme.bodySmall!.color,
      ),
      onPressed: () {
        BlocProvider.of<NavigationBloc>(context)
            .add(ChnangePage(pageIndex: index));
      },
    );
  }
}

class BottomBarItems extends StatelessWidget {
  const BottomBarItems({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        icon,
        color: Theme.of(context).textTheme.bodySmall!.color,
      ),
    );
  }
}
