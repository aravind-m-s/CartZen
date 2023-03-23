import 'dart:developer';

import 'package:cartzen/controllers/address/address_bloc.dart';
import 'package:flutter/material.dart';

import 'package:cartzen/views/common/default_back_button.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/core/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final TextEditingController name = TextEditingController();
final TextEditingController address = TextEditingController();
final TextEditingController locality = TextEditingController();
final TextEditingController pincode = TextEditingController();

class ScreenAddEditAddress extends StatelessWidget {
  const ScreenAddEditAddress(
      {super.key, this.adrs = const {}, this.index = -1});
  final Map<String, dynamic> adrs;
  final int index;

  modifyData() {
    name.text = adrs['name'];
    address.text = adrs['address'];
    locality.text = adrs['locality'];
    pincode.text = adrs['pincode'];
  }

  clear() {
    name.text = '';
    address.text = '';
    locality.text = '';
    pincode.text = '';
  }

  @override
  Widget build(BuildContext context) {
    clear();
    if (adrs.isNotEmpty && index != -1) {
      modifyData();
    }
    final GlobalKey formKey = GlobalKey<FormState>();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  kHeight,
                  DetailsInput(
                    formKey: formKey,
                  ),
                  kHeight,
                  SubmitButton(
                    isEdit: adrs.isNotEmpty,
                    index: index,
                    formKey: formKey,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 32,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined,
                size: 36,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsInput extends StatelessWidget {
  const DetailsInput({Key? key, required this.formKey}) : super(key: key);

  final formKey;
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
            controller: address,
            label: "Residence",
          ),
          kHeight,
          InputFieldWidget(
            controller: locality,
            label: "Locality",
          ),
          kHeight,
          InputFieldWidget(
            controller: pincode,
            label: "Pincode",
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
    required this.isEdit,
    required this.index,
  }) : super(key: key);
  final bool isEdit;
  final int index;
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
          onPressed: () async {
            if (isEdit) {
              editAddress(index, context);
            } else {
              await addAddress(context);
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

editAddress(int index, BuildContext context) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) async {
    final data = value.data();
    if (data != null) {
      final List addresses = data['address'] ?? [];
      addresses.removeAt(index);
      final adrs = {
        'name': name.text,
        'address': address.text,
        'locality': locality.text,
        'pincode': pincode.text
      };
      addresses.add(adrs);
      data['address'] = addresses;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(data);
    }
    Navigator.of(context).pop();
  });
}

Future addAddress(BuildContext context) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) async {
    log(value.data().toString());
    Map<String, dynamic>? user = value.data();
    final List adrs = user?['address'] ?? [];
    if (!adrs.contains({
      'name': name.text,
      'address': address.text,
      'locality': locality.text,
      'pincode': pincode.text
    })) {
      adrs.add({
        'name': name.text,
        'address': address.text,
        'locality': locality.text,
        'pincode': pincode.text
      });
      user?['address'] = adrs;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(user ?? {});
    }
    BlocProvider.of<AddressBloc>(context).add(GetAllAddress());
    Navigator.of(context).pop();
  });
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
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
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
        hintText: "Enter your $label",
        hintStyle: Theme.of(context).textTheme.bodySmall,
        label: Text(label),
        suffixIcon: label == "Residence"
            ? const Icon(Icons.home)
            : label == "Locality"
                ? const Icon(Icons.map)
                : label == "Pincode"
                    ? const Icon(Icons.mail_lock_sharp)
                    : const Icon(Icons.person),
      ),
      keyboardType: label == "Pincode" ? TextInputType.number : null,
    );
  }
}
