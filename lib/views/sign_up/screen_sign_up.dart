import 'package:cartzen/models/cart_model.dart';
import 'package:cartzen/models/user_model.dart';
import 'package:cartzen/views/common/snacbar.dart';
import 'package:cartzen/views/login/screen_login.dart';
import 'package:cartzen/views/bottom_sheet/bottom_sheet.dart';
import 'package:cartzen/views/common/default_auth_title.dart';
import 'package:cartzen/views/common/default_back_button.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/core/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScreenSignUp extends StatelessWidget {
  const ScreenSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    final TextEditingController rePassword = TextEditingController();
    final GlobalKey formKey = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/Background.png',
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(padding * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const DefaultAuthtTitle(
                    title: "Register Account",
                    subTitle:
                        "Complete your details or continue\nwith your Google account",
                  ),
                  kHeight50,
                  InputForm(
                    email: email,
                    password: password,
                    rePassword: rePassword,
                    formKey: formKey,
                  ),
                  kHeight,
                  SignUpButtonWidget(
                    formKey: formKey,
                    email: email,
                    password: password,
                  ),
                  kHeight,
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance
                          .signInWithProvider(GoogleAuthProvider())
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
                  kHeight,
                  const SignInWidget(),
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

class SignInWidget extends StatelessWidget {
  const SignInWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const ScreenLogin(),
          ),
        );
      },
      child: Text.rich(
        TextSpan(
          text: "Already have an account ? ",
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            TextSpan(
              text: "SignIn",
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

class InputForm extends StatelessWidget {
  const InputForm(
      {Key? key,
      required this.email,
      required this.password,
      required this.rePassword,
      required this.formKey})
      : super(key: key);

  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController rePassword;
  final GlobalKey formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          InputFieldWidget(
            controller: email,
            label: "Email",
          ),
          kHeight,
          InputFieldWidget(
            controller: password,
            label: "Password",
            password: rePassword,
          ),
          kHeight,
          InputFieldWidget(
            controller: rePassword,
            label: "Confirm Password",
            password: password,
          ),
        ],
      ),
    );
  }
}

class SignUpButtonWidget extends StatelessWidget {
  const SignUpButtonWidget({
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
              signUp(email, password, context).then((value) async {
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

                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const ScreenMain(),
                ));
              });
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

Future signUp(email, password, context) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(), password: password.text.trim());
  } catch (e) {
    showSuccessSnacbar(context, 'Something went wrong');
  }
}

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({
    Key? key,
    required this.controller,
    required this.label,
    this.password,
  }) : super(key: key);

  final TextEditingController controller;
  final TextEditingController? password;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (label == "Email") {
          return emailValidator(value);
        } else if (label == "Password") {
          return passwordValidator(value, password!);
        } else if (label == "Confirm Password") {
          return passwordValidator(value, password!);
        }
        return null;
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
        hintStyle: Theme.of(context).textTheme.bodySmall,
        label: Text(label),
        suffixIcon:
            label == "Email" ? const Icon(Icons.mail) : const Icon(Icons.lock),
      ),
      keyboardType: label == "Email" ? TextInputType.emailAddress : null,
      obscureText: label == "Email" ? false : true,
    );
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email Cannot be empty";
    } else if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? passwordValidator(String? value, TextEditingController password) {
    if (value == null || value.isEmpty) {
      if (label == "Password") {
        return "Password cannot be empty";
      } else {
        return "Confirm Password cannot be empty";
      }
    } else if (value.length < 6) {
      return "Password should be 6 letters";
    } else if (value != password.text) {
      if (label == "Password") {
        return null;
      } else {
        return "Passwords Must match";
      }
    }
    return null;
  }
}
