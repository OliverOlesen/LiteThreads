import 'package:flutter/material.dart';

void snackbarError(String err, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: const Duration(seconds: 5), content: Text(err)));
}
