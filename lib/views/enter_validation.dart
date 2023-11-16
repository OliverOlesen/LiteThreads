import 'package:flutter/material.dart';
import 'package:litethreads/components/custom_spacer.dart';
import 'package:litethreads/components/elevated_button.dart';
import 'package:litethreads/components/text_input.dart';

class TwoFactorCreate extends StatefulWidget {
  final String? email;
  final String? username;
  final String? password;
  final DateTime? birthdate;

  const TwoFactorCreate(
      this.email, this.username, this.password, this.birthdate,
      {Key? key})
      : super(key: key);

  @override
  State<TwoFactorCreate> createState() => _TwoFactorCreateState();
}

class _TwoFactorCreateState extends State<TwoFactorCreate> {
  TextEditingController validationCode = TextEditingController();

  void submitCode() {
    if (validationCode.text != "") {
      // TODO Make post-request
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController twoFactorCode = TextEditingController();

    void submitClicked() {}

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customSpacer(context, 0.1),
            const Text(
                "A code has been sent to your email. \nEnter the validation code below."),
            textInputField(twoFactorCode, "Validation code"),
            customSpacer(context, 0.1),
            eBtn(submitClicked, "Submit", Colors.blueAccent)
          ],
        ),
      ),
    );
  }
}
