import 'package:flutter/material.dart';

Row errorText(String txt) {
  return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
    Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Text(txt, style: const TextStyle(color: Colors.red)),
    ),
  ]);
}
