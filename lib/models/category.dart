class AppCategory {
  final String name;

  AppCategory({required this.name});

  factory AppCategory.fromJson(Map<String, dynamic> json) {
    return AppCategory(
      name: json['name'],
    );
  }
}
