import 'package:flutter/material.dart';

SizedBox customSpacer(BuildContext context, double h) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * h,
  );
}
