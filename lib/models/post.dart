class Post {
  final int id;
  final String title;
  final String excerpt;
  final String content;
  final String featuredImage;
  final String author;
  final DateTime publishedDate;
  final int categoryId;

  Post({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.featuredImage,
    required this.author,
    required this.publishedDate,
    required this.categoryId,
  });
}