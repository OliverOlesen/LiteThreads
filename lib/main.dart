import 'package:flutter/material.dart';
import 'package:litethreads/globals/variables.dart';
import 'package:litethreads/views/login.dart';
import 'package:litethreads/views/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lite Threads',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: global_username != ""
          ? PageNavigation(
              email: global_email,
              username: global_username,
            )
          : const Login(),
      // home:
      //     PageNavigation(email: "", birthdate: "", username: "", password: ""),
    );
  }
}
