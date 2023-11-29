import 'package:litethreads/models/group.dart';

class User {
  final String username;
  final String email;
  final String password;
  final String birthdate;
  final List<String> posts;
  final List<Group> groups;

  User(
      {required this.username,
      required this.password,
      required this.email,
      required this.birthdate,
      required this.posts,
      required this.groups});

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'username': String username,
        'password': String password,
        'email': String email,
        'birthdate': String birthDate
      } =>
        User(
            username: username,
            password: password,
            email: email,
            birthdate: birthDate,
            posts: List.empty(),
            groups: List.empty()),
      _ => throw const FormatException("Failed to save user locally")
    };
  }
}
