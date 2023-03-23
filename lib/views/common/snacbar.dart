import 'package:flutter/material.dart';

showSuccessSnacbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.green,
    duration: const Duration(milliseconds: 500),
  ));
}
