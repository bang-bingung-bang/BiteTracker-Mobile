class CommentData {
  final int id;
  final String user;
  final String content;
  final int userId;

  CommentData({
    required this.id,
    required this.user,
    required this.content,
    required this.userId,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        id: json["id"],
        user: json["user"],
        content: json["content"],
        userId: json["user_id"],
      );
}