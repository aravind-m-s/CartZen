import 'package:cartzen/controllers/address/address_bloc.dart';
import 'package:cartzen/core/constants.dart';
import 'package:cartzen/views/add_edit_address/screen_add_edit_address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenAddress extends StatelessWidget {
  const ScreenAddress({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AddressBloc>(context).add(GetAllAddress());
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(padding * 2),
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                Expanded(
                  child: BlocBuilder<AddressBloc, AddressState>(
                    builder: (context, state) {
                      if (state.address.isEmpty) {
                        return Center(
                          child: Text(
                            'No addresses Yet',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        );
                      }
                      return ListView.separated(
                          itemBuilder: (context, index) {
                            final address = state.address[index];
                            return AddressWidget(
                              address: address,
                              index: index,
                            );
                          },
                          separatorBuilder: (context, index) => kHeight,
                          itemCount: state.address.length);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Appbar(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ScreenAddEditAddress(),
          ));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AddressWidget extends StatelessWidget {
  const AddressWidget({
    super.key,
    required this.address,
    required this.index,
  });
  final address;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 165,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AddressCard(address: address),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Are you sure"),
                        content: Text(
                          "Do you want to delete this address",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "cancel",
                                style: Theme.of(context).textTheme.titleSmall,
                              )),
                          TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get()
                                  .then((value) async {
                                final data = value.data() ?? {};
                                final List addresses = data['address'] ?? [];
                                addresses.removeAt(index);
                                data['address'] = addresses;
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update(data)
                                    .then((value) {
                                  BlocProvider.of<AddressBloc>(context)
                                      .add(GetAllAddress());
                                });
                              });
                              Navigator.of(context).pop();
                              BlocProvider.of<AddressBloc>(context)
                                  .add(GetAllAddress());
                            },
                            child: Text(
                              "OK",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ScreenAddEditAddress(
                        adrs: address,
                        index: index,
                      ),
                    ));
                  },
                  icon: const Icon(Icons.edit))
            ],
          )
        ],
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  const AddressCard({
    required this.address,
    super.key,
  });
  final address;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressText(text: address['name']),
        AddressText(text: address['address']),
        AddressText(text: address['locality']),
        AddressText(text: address['pincode']),
      ],
    );
  }
}

class AddressText extends StatelessWidget {
  const AddressText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class Appbar extends StatelessWidget {
  const Appbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomAppBar(),
      child: Container(
        height: 200,
        width: double.infinity,
        color: themeColor,
        child: Padding(
          padding: const EdgeInsets.only(top: padding * 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Text(
                "Address",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 360;
    final double yScaling = size.height / 141;
    path.lineTo(102.515 * xScaling, 120.478 * yScaling);
    path.cubicTo(
      223.94 * xScaling,
      66.9138 * yScaling,
      322.794 * xScaling,
      103.867 * yScaling,
      360.271 * xScaling,
      126.185 * yScaling,
    );
    path.cubicTo(
      360.271 * xScaling,
      126.185 * yScaling,
      360.271 * xScaling,
      0 * yScaling,
      360.271 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      360.271 * xScaling,
      0 * yScaling,
      -0.0000305176 * xScaling,
      0 * yScaling,
      -0.0000305176 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      -0.0000305176 * xScaling,
      0 * yScaling,
      0 * xScaling,
      138.819 * yScaling,
      0 * xScaling,
      138.819 * yScaling,
    );
    path.cubicTo(
      23.2431 * xScaling,
      143.967 * yScaling,
      56.3983 * xScaling,
      140.822 * yScaling,
      102.515 * xScaling,
      120.478 * yScaling,
    );
    path.cubicTo(
      102.515 * xScaling,
      120.478 * yScaling,
      102.515 * xScaling,
      120.478 * yScaling,
      102.515 * xScaling,
      120.478 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
