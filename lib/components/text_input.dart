import 'package:flutter/material.dart';

Container textInputField(TextEditingController tec, String hint) {
  return Container(
      padding: const EdgeInsets.all(15),
      child: TextFormField(
        controller: tec,
        decoration: InputDecoration(hintText: "Enter $hint"),
        validator: (value) {
          if (hint.toLowerCase().contains("email")) {
            // Use a regular expression to check if the value is a valid email
            bool isValidEmail = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                .hasMatch(value!);
            if (!isValidEmail) {
              return 'Please enter a valid email address';
            }
          }
          if (value == null || value.isEmpty) {
            return 'Please enter valid ${hint.toLowerCase()}';
          }

          return null;
        },
      ));
}
