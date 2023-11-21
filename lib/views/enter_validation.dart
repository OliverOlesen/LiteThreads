import 'package:flutter/material.dart';
import 'package:litethreads/components/custom_spacer.dart';
import 'package:litethreads/components/elevated_button.dart';
import 'package:litethreads/components/fetch.dart';
import 'package:litethreads/components/text_input.dart';
import 'package:litethreads/views/navigation.dart';

class TwoFactorCreate extends StatefulWidget {
  final String? email;
  final String? username;
  final String? password;
  final String? birthdate;

  const TwoFactorCreate(
      this.email, this.username, this.password, this.birthdate,
      {Key? key})
      : super(key: key);

  @override
  State<TwoFactorCreate> createState() => _TwoFactorCreateState();
}

class _TwoFactorCreateState extends State<TwoFactorCreate> {
  TextEditingController validationCode = TextEditingController();
  TextEditingController twoFactorCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void submitCode() {
      if (twoFactorCode.text != "") {
        print("HEJ");
        // TODO Make post-request
        var jsonBody = {
          "username": widget.username,
          "password": widget.password,
          "birthdate": widget.birthdate.toString(),
          "verif_code": twoFactorCode.text
        };
        fetch("/", jsonBody).then((value) {
          if (value.status == "ok") {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageNavigation(
                        username: widget.username,
                        email: widget.email,
                        password: widget.password,
                        birthdate: widget.birthdate)));
          }
        });
      }
    }

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
            eBtn(submitCode, "Submit", Colors.blueAccent)
          ],
        ),
      ),
    );
  }
}
