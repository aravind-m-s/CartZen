import 'package:flutter/material.dart';

class DefaultBackButton extends StatelessWidget {
  const DefaultBackButton({
    Key? key,
    this.isBack = false,
  }) : super(key: key);
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
    );
  }
}
