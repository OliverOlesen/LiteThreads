import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:litethreads/components/elevated_button.dart';
import 'package:litethreads/components/text_input.dart';
import 'package:litethreads/views/enter_validation.dart';

class CreateUserView extends StatefulWidget {
  const CreateUserView({super.key});

  @override
  State<CreateUserView> createState() => _CreateUserViewState();
}

class _CreateUserViewState extends State<CreateUserView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DateTime pickerData = DateTime(1990, 1, 1);
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void openDatePicker(Widget child) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
      );
    }

    void submitClicked() {
      if (_key.currentState!.validate()) {
        if (emailController.text != "" &&
            usernameController.text != "" &&
            passwordController.text != "") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TwoFactorCreate(
                      emailController.text,
                      usernameController.text,
                      passwordController.text,
                      pickerData)));
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Processing Data')), // TODO skift til DB post-request
        );
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Create New User"),
                textInputField(emailController, "Email"),
                textInputField(usernameController, "Username"),
                textInputField(passwordController, "Password"),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Text("Select Birthdate"),
                      TextButton(
                          onPressed: () {
                            openDatePicker(
                              CupertinoDatePicker(
                                initialDateTime: pickerData,
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(() => pickerData = newDate);
                                },
                              ),
                            );
                          },
                          child: Text(
                              "${pickerData.day}/${pickerData.month}/${pickerData.year}")),
                    ],
                  ),
                ),
                eBtn(submitClicked, "Create", Colors.blueAccent)
              ],
            ),
          ),
        )),
      ),
    );
  }
}