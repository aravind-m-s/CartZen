import 'package:cartzen/models/user_model.dart';
import 'package:cartzen/views/common/default_back_button.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/core/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final TextEditingController name = TextEditingController();
final TextEditingController email = TextEditingController();
final TextEditingController phone = TextEditingController();
final GlobalKey formKey = GlobalKey<FormState>();

class ScreenUserDetails extends StatelessWidget {
  const ScreenUserDetails({super.key});

  getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      if (value.data() != null) {
        name.text = value.data()!['name'];
        phone.text = value.data()!['mobile'];
        email.text = value.data()!['email'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Background.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(padding * 2),
              child: ListView(
                children: [
                  const SizedBox(height: 100),
                  DetailsInput(name: name, email: email, phone: phone),
                  kHeight,
                  SubmitButton(
                    formKey: formKey,
                    name: name,
                    email: email,
                    mobile: phone,
                  )
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

class DetailsInput extends StatelessWidget {
  const DetailsInput({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
  }) : super(key: key);

  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController phone;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          InputFieldWidget(
            controller: name,
            label: "Name",
          ),
          kHeight,
          InputFieldWidget(
            controller: email,
            label: "Email",
          ),
          kHeight,
          InputFieldWidget(
            controller: phone,
            label: "Mobile",
          ),
          kHeight,
        ],
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key? key,
    required this.formKey,
    required this.name,
    required this.email,
    required this.mobile,
  }) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final formKey;
  final TextEditingController email;
  final TextEditingController name;
  final TextEditingController mobile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(defaultRadius),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: themeColor),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              await editDetails(name, email, mobile);
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

Future editDetails(
  TextEditingController name,
  TextEditingController email,
  TextEditingController mobile,
) async {
  final instance = FirebaseAuth.instance.currentUser!;
  instance.updateDisplayName(name.text.trim());
  instance.updateEmail(email.text.trim());
  final users =
      FirebaseFirestore.instance.collection('users').doc(instance.uid);
  final data = UserModel(
    name: name.text.trim(),
    email: email.text.trim(),
    mobile: mobile.text,
    id: instance.uid,
  ).toJson();
  users.update(data);
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
        suffixIcon: label == "Email"
            ? const Icon(Icons.mail)
            : label == "Mobile"
                ? const Icon(Icons.phone_android_rounded)
                : const Icon(Icons.person),
      ),
      keyboardType: label == "Email"
          ? TextInputType.emailAddress
          : label == "Mobile"
              ? TextInputType.number
              : null,
    );
  }
}
