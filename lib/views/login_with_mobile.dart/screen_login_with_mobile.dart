import 'package:cartzen/core/constants.dart';
import 'package:cartzen/models/cart_model.dart';
import 'package:cartzen/models/user_model.dart';
import 'package:cartzen/views/bottom_sheet/bottom_sheet.dart';
import 'package:cartzen/views/common/default_auth_title.dart';
import 'package:cartzen/views/sign_up/screen_sign_up.dart';
import 'package:cartzen/views/user_detials/screen_user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

String verification = '';
final TextEditingController countryController = TextEditingController();
final TextEditingController mobile = TextEditingController();

class ScreenLoginOTP extends StatelessWidget {
  const ScreenLoginOTP({super.key});

  update() {
    countryController.text = '+91';
  }

  @override
  Widget build(BuildContext context) {
    update();
    final GlobalKey mobileKey = GlobalKey<FormState>();
    final GlobalKey otpKey = GlobalKey<FormState>();
    final TextEditingController otp = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/Background.png'), fit: BoxFit.fill),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const DefaultAuthtTitle(
                  title: "Log in with mobile",
                  subTitle:
                      "Please enter your mobile number and\nwe will send you an OTP to verify",
                ),
                const SizedBox(
                  height: 50,
                ),
                MobileInput(mobileKey: mobileKey),
                kHeight10,
                ConfirmButton(mobileKey: mobileKey),
                kHeight10,
                const DefaultAuthtTitle(title: "Enter the OTP", subTitle: ""),
                OTPInput(formKey: otpKey, controller: otp),
                kHeight10,
                LogIn(
                  formKey: otpKey,
                  otp: otp,
                ),
                const SizedBox(
                  height: 50,
                ),
                const SingUpWidget(),
              ],
            ),
          ),
        ),
        // const DefaultBackButton(),
      ]),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    Key? key,
    required this.mobileKey,
  }) : super(key: key);
  final mobileKey;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: themeColor),
          onPressed: () {
            if (mobileKey.currentState!.validate()) {
              FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: countryController.text + mobile.text,
                verificationCompleted: (phoneAuthCredential) {},
                verificationFailed: (error) {},
                codeSent: (verificationId, forceResendingToken) {
                  verification = verificationId;
                },
                codeAutoRetrievalTimeout: (verificationId) {},
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

class LogIn extends StatelessWidget {
  const LogIn({
    Key? key,
    required this.formKey,
    required this.otp,
  }) : super(key: key);
  final formKey;
  final TextEditingController otp;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: themeColor),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verification, smsCode: otp.text.trim());
                await FirebaseAuth.instance
                    .signInWithCredential(credential)
                    .then((value) async {
                  final uid = FirebaseAuth.instance.currentUser!.uid;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .set(UserModel(
                              id: FirebaseAuth.instance.currentUser!.uid,
                              email: email.text.trim())
                          .toJson())
                      .then((value) async {
                    await FirebaseFirestore.instance
                        .collection('cart')
                        .doc(uid)
                        .set(CartModel(id: uid, products: []).toJson());
                  });

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ScreenMain(),
                  ));
                });
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("OOps!!"),
                    content: const Text(
                        'Something Went wrong please try again later'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'))
                    ],
                  ),
                );
              }
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
          decoration: BoxDecoration(
              color: const Color.fromRGBO(222, 231, 240, .57),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: themeColor)),
          width: 56,
          height: 60,
          textStyle: const TextStyle(
            fontSize: 20,
          ),
        ),
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
        Navigator.of(context).pushReplacement(
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
                    color: Colors.teal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileInput extends StatelessWidget {
  const MobileInput({
    Key? key,
    required this.mobileKey,
  }) : super(key: key);

  final mobileKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Form(
        key: mobileKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 40,
              child: TextFormField(
                validator: (value) {
                  if (value!.length > 3 || value.length < 3) {
                    return "Enter a valid country code";
                  } else if (value.isEmpty) {
                    return "Country Code cannot be empty";
                  } else {
                    return null;
                  }
                },
                style: const TextStyle(color: Colors.black),
                controller: countryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const Text(
              "|",
              style: TextStyle(fontSize: 33, color: Colors.grey),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: TextFormField(
              validator: (value) {
                if (value!.length > 10 || value.length < 10) {
                  return "Enter a valid mobile number";
                } else if (value.isEmpty) {
                  return "Mobile number cannot be empty";
                } else {
                  return null;
                }
              },
              controller: mobile,
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.phone_android),
                border: InputBorder.none,
                hintText: "Phone",
              ),
            ))
          ],
        ),
      ),
    );
  }
}
