import 'package:cartzen/models/cart_model.dart';
import 'package:cartzen/models/user_model.dart';
import 'package:cartzen/views/bottom_sheet/bottom_sheet.dart';
import 'package:cartzen/views/common/default_auth_title.dart';
import 'package:cartzen/views/common/default_back_button.dart';
import 'package:cartzen/views/common/snacbar.dart';
import 'package:cartzen/views/login_with_mobile.dart/screen_login_with_mobile.dart';
import 'package:cartzen/views/sign_up/screen_sign_up.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/core/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/Background.png'), fit: BoxFit.fill),
            ),
            child: Padding(
              padding: const EdgeInsets.all(padding * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const DefaultAuthtTitle(
                      title: "Welcome Back",
                      subTitle:
                          "Sing in with your email and password or continue\nwith your Google account or Mobile"),
                  kHeight50,
                  InputForm(
                    email: email,
                    password: password,
                    formKey: formKey,
                  ),
                  kHeight,
                  kHeight,
                  LoginButtonWidget(
                    formKey: formKey,
                    email: email,
                    password: password,
                  ),
                  kHeight,
                  const OtherSingInMethods(),
                  kHeight,
                  const SingUpWidget(),
                ],
              ),
            ),
          ),
          const DefaultBackButton(
            isBack: true,
          )
        ],
      ),
    );
  }
}

class InputForm extends StatelessWidget {
  const InputForm({
    Key? key,
    required this.email,
    required this.password,
    required this.formKey,
  }) : super(key: key);

  final TextEditingController email;
  final TextEditingController password;
  final GlobalKey formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          inputField(email, "Email"),
          kHeight,
          inputField(password, "Password")
        ],
      ),
    );
  }

  TextFormField inputField(TextEditingController controller, String label) {
    return TextFormField(
      validator: (value) {
        return validate(value, label);
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
        hintText: "Enter your $label",
        label: Text(label),
        suffixIcon:
            label == "Email" ? const Icon(Icons.mail) : const Icon(Icons.lock),
      ),
      keyboardType: label == "Email" ? TextInputType.emailAddress : null,
      obscureText: label == "Email" ? false : true,
    );
  }
}

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({
    Key? key,
    required this.formKey,
    required this.email,
    required this.password,
  }) : super(key: key);
  final TextEditingController email;
  final TextEditingController password;
  // ignore: prefer_typing_uninitialized_variables
  final formKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(defaultRadius),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: themeColor),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              singIn(email, password, context);
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

Future singIn(TextEditingController email, TextEditingController password,
    context) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email.text.trim(),
      password: password.text.trim(),
    )
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

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ScreenMain(),
      ));
    });
  } catch (e) {
    showSuccessSnacbar(context, 'Something went wrong');
  }
}

class OtherSingInMethods extends StatelessWidget {
  const OtherSingInMethods({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        kWidth10,
        GestureDetector(
          onTap: () async {
            await FirebaseAuth.instance
                .signInWithProvider(GoogleAuthProvider())
                .then((value) async {
              final uid = FirebaseAuth.instance.currentUser!.uid;
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .set(UserModel(
                          id: FirebaseAuth.instance.currentUser!.uid,
                          email: FirebaseAuth.instance.currentUser!.email ?? '')
                      .toJson())
                  .then((value) async {
                await FirebaseFirestore.instance
                    .collection('cart')
                    .doc(uid)
                    .set(CartModel(id: uid, products: []).toJson());
              });

              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ScreenMain(),
              ));
            });
          },
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/Google.png'),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const ScreenLoginOTP(),
              ),
            );
          },
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.transparent,
            child: Image.asset('assets/mobile.png'),
          ),
        ),
        kWidth10,
      ],
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

String? validate(String? value, String label) {
  if (value == null || value.isEmpty) {
    return "$label cannot be empty";
  } else if (value.length < 6 && label == "Password") {
    return "Password should be more than 6 letters";
  } else if (label == "Email" &&
      !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(value)) {
    return "Enter a valid email";
  }
  return null;
}
