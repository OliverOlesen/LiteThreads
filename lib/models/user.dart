class User {
  final String username;
  final String email;
  final String password;
  final String birthdate;
  final List<String> posts;

  User(
      {required this.username,
      required this.password,
      required this.email,
      required this.birthdate,
      required this.posts});

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
            posts: List.empty()),
      _ => throw const FormatException("Failed to save user locally")
    };
  }
}
