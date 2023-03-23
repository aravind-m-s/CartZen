import 'package:cartzen/controllers/address/address_bloc.dart';
import 'package:cartzen/controllers/banner/banner_bloc.dart';
import 'package:cartzen/controllers/category/category_bloc.dart';
import 'package:cartzen/controllers/coupon/coupon_bloc.dart';
import 'package:cartzen/controllers/order/order_bloc.dart';
import 'package:cartzen/controllers/search/search_bloc.dart';
import 'package:cartzen/controllers/wallet/wallet_bloc.dart';
import 'package:cartzen/controllers/whishlist/whishlist_bloc.dart';
import 'package:cartzen/views/bottom_sheet/bottom_sheet.dart';
import 'package:cartzen/controllers/cart/cart_bloc.dart';
import 'package:cartzen/controllers/cart_quantity/cart_quantity_bloc.dart';
import 'package:cartzen/controllers/home/home_bloc.dart';
import 'package:cartzen/controllers/navigation/navigation_bloc.dart';
import 'package:cartzen/controllers/product_details/product_details_bloc.dart';
import 'package:cartzen/controllers/theme/theme_bloc.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/core/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? darkTheme = prefs.getBool('darkTheme');
  runApp(MyApp(darkThemeStatus: darkTheme ?? false));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.darkThemeStatus});
  final bool darkThemeStatus;

  @override
  Widget build(BuildContext context) {
    if (ThemeMode.system == ThemeMode.dark) {
      darkMode = false;
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => ProductDetailsBloc(),
        ),
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider(
          create: (context) => CartQuantityBloc(),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(),
        ),
        BlocProvider(
          create: (context) => WhishlistBloc(),
        ),
        BlocProvider(
          create: (context) => AddressBloc(),
        ),
        BlocProvider(
          create: (context) => BannerBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
        BlocProvider(
          create: (context) => WalletBloc(),
        ),
        BlocProvider(
          create: (context) => CouponBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final dark = state.darkTheme ?? darkThemeStatus;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: dark ? ThemeMode.dark : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const ScreenMain(),
          );
        },
      ),
    );
  }
}
