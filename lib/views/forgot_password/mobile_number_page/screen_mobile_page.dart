import 'package:cartzen/views/common/default_auth_title.dart';
import 'package:cartzen/views/common/default_back_button.dart';
import 'package:cartzen/views/forgot_password/OTP_page/screen_forgot_otp.dart';
import 'package:cartzen/views/sign_up/screen_sign_up.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/core/themes.dart';
import 'package:flutter/material.dart';

class ScreenForgotPswdMobile extends StatelessWidget {
  const ScreenForgotPswdMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final GlobalKey formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Background.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(padding * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const DefaultAuthtTitle(
                    title: "Forgot Password",
                    subTitle:
                        "Please enter your mobile number and\nwe will send you an OTP to verify",
                  ),
                  kHeight50,
                  InputForm(formKey: formKey, controller: controller),
                  kHeight50,
                  ContinueToOTP(formKey: formKey),
                  kHeight50,
                  const SingUpWidget(),
                ],
              ),
            ),
          ),
          const DefaultBackButton()
        ],
      ),
    );
  }
}

class SingUpWidget extends StatelessWidget {
  const SingUpWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const ScreenSignUp(),
          ),
        );
      },
      child: Text.rich(
        TextSpan(
          text: "Don't have an account ? ",
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            TextSpan(
              text: "SignUp",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: themeColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContinueToOTP extends StatelessWidget {
  const ContinueToOTP({
    Key? key,
    required this.formKey,
  }) : super(key: key);
  final formKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(defaultRadius),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const ScreenForgotPswdOTP(),
              ),
            );
          },
          child: Text(
            'Continue',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class InputForm extends StatelessWidget {
  const InputForm({
    Key? key,
    required this.formKey,
    required this.controller,
  }) : super(key: key);

  final GlobalKey<State<StatefulWidget>> formKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Mobile number cannot be empty";
          } else if (value.length != 12) {
            return "Please enter a valid mobile number";
          } else {
            return null;
          }
        },
        style: TextStyle(color: darkMode ? Colors.white : Colors.black),
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(defaultRadius),
            borderSide: BorderSide(
              color: darkMode ? darkSubTitleColor : lightSubTitleColor,
            ),
          ),
          hintText: "Enter your Mobile number",
          hintStyle: Theme.of(context).textTheme.bodySmall,
          label: const Text("Mobile"),
          prefixIcon: const Icon(
            Icons.add,
            color: Colors.black,
          ),
          suffixIcon: const Icon(
            Icons.phone_android_rounded,
          ),
        ),
      ),
    );
  }
}
