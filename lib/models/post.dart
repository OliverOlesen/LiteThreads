// ignore_for_file: non_constant_identifier_names

class Post {
  late String id;
  late String username;
  late String group_name;
  late String title;
  late String content;
  late DateTime creationDate;
  late int likes;
  late int dislikes;
  late int? userVote;

  Post({
    required this.id,
    required this.username,
    required this.group_name,
    required this.title,
    required this.content,
    required this.creationDate,
    required this.likes,
    required this.dislikes,
    required this.userVote,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      username: json['username'],
      group_name: json['group_name'] ?? "",
      title: json['title'],
      content: json['content'],
      creationDate: DateTime.parse(json['creation_date']),
      likes: int.parse(json['likes']),
      dislikes: int.parse(json['dislikes']),
      userVote: json['user_vote'] != null ? int.parse(json['user_vote']) : null,
    );
  }
}
