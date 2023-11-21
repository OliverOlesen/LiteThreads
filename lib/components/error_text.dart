import 'package:flutter/material.dart';

Row errorText(String txt) {
  return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
    Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: Text(txt, style: TextStyle(color: Colors.red)),
    ),
  ]);
}
