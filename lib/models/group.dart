import 'package:litethreads/models/status.dart';

class Group {
  final HttpStatusSuccess? status;
  final String name;
  // final String? category;
  // final bool? ageRestricted;
  // final int? memberCount;

  Group({
    this.status,
    required this.name,
    // this.category,
    // this.ageRestricted,
    // this.memberCount
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        // 'category': String? category,
        // 'ageRestricted': bool? ageRestricted,
        // 'memberCount': int? memberCount
      } =>
        Group(
          name: name,
          // category: category ?? "",
          // ageRestricted: ageRestricted ?? false,
          // memberCount: memberCount ?? 0
        ),
      _ => throw const FormatException('Failed to Group.'),
    };
  }
}
