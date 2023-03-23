import 'package:cartzen/views/login/screen_login.dart';
import 'package:cartzen/views/address/screen_address.dart';
import 'package:cartzen/views/bottom_sheet/bottom_sheet.dart';
import 'package:cartzen/views/profile/widgets/app_bar.dart';
import 'package:cartzen/controllers/navigation/navigation_bloc.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/views/user_detials/screen_user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenProfile extends StatelessWidget {
  const ScreenProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 240,
                left: padding * 2,
                right: padding * 2,
              ),
              child: FirebaseAuth.instance.currentUser == null
                  ? const ProfileButton(index: 4)
                  : ListView(
                      children: List.generate(
                          4, (index) => ProfileButton(index: index)),
                    ),
            ),
            const CurvedAppBar(),
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "Edit Profile",
      "Addresses",
      "My Orders",
      "Logout",
      "Login",
    ];
    final List<IconData> icons = [
      Icons.person,
      Icons.chrome_reader_mode_rounded,
      Icons.assignment_rounded,
      Icons.logout,
      Icons.login
    ];
    return Column(
      children: [
        InkWell(
          onTap: () {
            _clicked(index, context);
          },
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultRadius),
                border: Border.all(color: themeColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  icons[index],
                  color: themeColor,
                ),
                Text(
                  titles[index],
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: themeColor, fontSize: 20),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: themeColor,
                )
              ],
            ),
          ),
        ),
        kHeight,
      ],
    );
  }

  _clicked(int index, BuildContext context) {
    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ScreenUserDetails(),
      ));
    } else if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ScreenAddress(),
      ));
    } else if (index == 2) {
      BlocProvider.of<NavigationBloc>(context)
          .add(ChnangePage(pageIndex: ordersIndex));
    } else if (index == 3) {
      FirebaseAuth.instance.signOut().then((value) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ScreenMain(),
        ));
      });
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ScreenLogin(),
      ));
    }
  }
}
