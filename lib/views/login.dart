import 'package:flutter/material.dart';
import 'package:litethreads/components/custom_spacer.dart';
import 'package:litethreads/components/elevated_button.dart';
import 'package:litethreads/components/text_input.dart';
import 'package:litethreads/views/create_user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void loginPressed() {
      if (_key.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Processing Data')), // TODO Skift til DB post-request
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
                  customSpacer(context, 0.1),
                  const Text(
                    "Lite Threads",
                    style: TextStyle(fontSize: 30),
                  ),
                  textInputField(emailController, "Email"),
                  textInputField(passController, "Password"),
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: eBtn(loginPressed, "Login", Colors.blueAccent)),
                  customSpacer(context, 0.1),
                  const Text("Are you new here?"),
                  TextButton(
                      onPressed: () {
                        // Navigate to Create User
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateUserView()));
                      },
                      child: const Text("Create a User")),
                  customSpacer(context, 0.1)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}