class Post {
  final int id;
  final String title;
  final String slug;
  final String excerpt;
  final String content;
  final String featuredImage;
  final Author author;
  final String publishedAt;
  final Category category;

  Post({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    required this.featuredImage,
    required this.author,
    required this.publishedAt,
    required this.category,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      title: _decodeHtmlEntities(json['title']?['rendered'] ?? 'Untitled'),
      slug: json['slug'] ?? '',
      excerpt: _cleanExcerpt(json['excerpt']?['rendered'] ?? ''),
      content: json['content']?['rendered'] ?? '',
      featuredImage: _getFeaturedImageUrl(json),
      author: Author.fromJson(json['_embedded']?['author']?[0] ?? {}),
      publishedAt: json['date'] ?? DateTime.now().toIso8601String(),
      category: Category.fromJson(json['_embedded']?['wp:term']?[0]?[0] ?? {}),
    );
  }

  static String _getFeaturedImageUrl(Map<String, dynamic> json) {
    try {
      // Check if featured media exists in embedded data
      if (json['_embedded'] != null && 
          json['_embedded']['wp:featuredmedia'] != null &&
          json['_embedded']['wp:featuredmedia'].isNotEmpty) {
        
        final media = json['_embedded']['wp:featuredmedia'][0];
        if (media['source_url'] != null && media['source_url'].isNotEmpty) {
          return media['source_url'];
        }
      }
      
      // Fallback to featured_media ID if available
      if (json['featured_media'] != null && json['featured_media'] > 0) {
        // Return a default image URL for posts with featured media but no embedded data
        return 'https://elfignentertainment.com/aspio/wp-content/uploads/2025/09/aspio-image-social.jpg';
      }
      
      return ''; // Return empty string if no image
    } catch (e) {
      print('Error getting featured image URL: $e');
      return '';
    }
  }

  static String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&hellip;', '...')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#8217;', "'")
        .replaceAll('&#8220;', '"')
        .replaceAll('&#8221;', '"')
        .trim();
  }

  static String _cleanExcerpt(String htmlContent) {
    String cleanText = htmlContent.replaceAll(RegExp(r'<[^>]*>'), '');
    cleanText = _decodeHtmlEntities(cleanText);
    
    if (cleanText.length <= 200) return cleanText;
    
    String truncated = cleanText.substring(0, 200);
    int lastSpaceIndex = truncated.lastIndexOf(' ');
    
    if (lastSpaceIndex > 0) {
      return truncated.substring(0, lastSpaceIndex) + '...';
    }
    
    return truncated + '...';
  }
}

class Author {
  final int id;
  final String name;
  final String avatar;

  Author({required this.id, required this.name, required this.avatar});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Author',
      avatar: json['avatar_urls']?['96'] ?? '/placeholder-user.jpg',
    );
  }
}

class Category {
  final int id;
  final String name;
  final String slug;
  final String description;
  final int postCount;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.postCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: Post._decodeHtmlEntities(json['name'] ?? 'Uncategorized'),
      slug: json['slug'] ?? 'uncategorized',
      description: Post._decodeHtmlEntities(json['description'] ?? ''),
      postCount: json['count'] ?? 0,
    );
  }
}