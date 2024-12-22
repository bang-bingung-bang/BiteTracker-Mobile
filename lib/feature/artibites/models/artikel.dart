class Artikel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String createdAt;

  Artikel({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl = '',
    required this.createdAt,
  });
}
