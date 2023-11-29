class Post {
  final String title;
  final String content;
  final DateTime createdDate;
  final String author;
  final int? groupID;
  final int likes;
  final int dislikes;

  Post(
      {required this.title,
      required this.content,
      required this.createdDate,
      required this.author,
      this.groupID,
      required this.likes,
      required this.dislikes});

  factory Post.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "title": String title,
        "content": String content,
        "createdDate": DateTime createdDate,
        "author": String author,
        "group_id": int groupId,
        "likes": int likes,
        "dislikes": int dislikes
      } =>
        Post(
            title: title,
            content: content,
            createdDate: createdDate,
            author: author,
            groupID: groupId,
            likes: likes,
            dislikes: dislikes),
      _ => throw const FormatException('Failed to load Post.'),
    };
  }
}
