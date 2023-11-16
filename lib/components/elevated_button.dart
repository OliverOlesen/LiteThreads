import 'package:flutter/material.dart';

ElevatedButton eBtn(Function logic, String btnText, Color btnColor) {
  return ElevatedButton(
      onPressed: () {
        logic();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: btnColor,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      ),
      child: Text(
        btnText,
        style: TextStyle(
          fontSize: 20,
          color:
              btnColor == Colors.blueAccent ? Colors.white : Colors.blueAccent,
        ),
      ));
}
