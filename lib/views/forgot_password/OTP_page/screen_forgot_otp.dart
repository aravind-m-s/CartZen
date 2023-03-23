import 'package:cartzen/views/Login/screen_login.dart';
import 'package:cartzen/views/common/default_auth_title.dart';
import 'package:cartzen/views/common/default_back_button.dart';
import 'package:cartzen/views/sign_up/screen_sign_up.dart';
import 'package:cartzen/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class ScreenForgotPswdOTP extends StatelessWidget {
  const ScreenForgotPswdOTP({super.key});

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
                    title: 'Forgot Password',
                    subTitle:
                        "Enter the 6 digit OTP which was\nsend to your mobile",
                  ),
                  kHeight50,
                  OTPInput(formKey: formKey, controller: controller),
                  kHeight50,
                  ContinueToHome(formKey: formKey),
                  kHeight50,
                  const SingUpWidget()
                ],
              ),
            ),
          ),
          const DefaultBackButton(),
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

class OTPInput extends StatelessWidget {
  const OTPInput({
    Key? key,
    required this.formKey,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;
  final GlobalKey<State<StatefulWidget>> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Pinput(
        controller: controller,
        validator: (value) =>
            value == null || value.isEmpty || value.length != 6
                ? "Enter a valid OTP"
                : null,
        length: 6,
        defaultPinTheme: PinTheme(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(222, 231, 240, .57),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          width: 56,
          height: 60,
          textStyle: TextStyle(
            color: darkMode ? Colors.white : Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class ContinueToHome extends StatelessWidget {
  const ContinueToHome({
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
            if (formKey.currentState!.validate()) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const ScreenLogin(),
                ),
              );
            }
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
