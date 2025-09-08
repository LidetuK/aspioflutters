'''
import 'package:myapp/models/category.dart';
import 'package:myapp/models/post.dart';

class MockDataService {
  static List<Post> getPosts() {
    return [
      Post(
        id: 1,
        title: 'The Art of Flutter Development',
        excerpt: 'Discover the secrets behind building beautiful and high-performance apps with Flutter...',
        content: 'Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase. In this post, we explore the various aspects of Flutter development that make it a popular choice for developers.',
        featuredImage: 'https://picsum.photos/seed/1/600/400',
        author: 'John Doe',
        publishedDate: DateTime(2023, 10, 26),
        categoryId: 1,
      ),
      Post(
        id: 2,
        title: 'State Management in Flutter',
        excerpt: 'A deep dive into the most popular state management techniques in Flutter...',
        content: 'State management is a crucial part of any Flutter application. This article covers various approaches, from simple solutions like setState to more advanced patterns using Provider and BLoC.',
        featuredImage: 'https://picsum.photos/seed/2/600/400',
        author: 'Jane Smith',
        publishedDate: DateTime(2023, 10, 25),
        categoryId: 1,
      ),
      Post(
        id: 3,
        title: 'Exploring the World of Dart',
        excerpt: 'Learn about the powerful language that powers Flutter...',
        content: 'Dart is an object-oriented, class-based, garbage-collected language with C-style syntax. This post provides a comprehensive overview of the Dart language and its features.',
        featuredImage: 'https://picsum.photos/seed/3/600/400',
        author: 'Peter Jones',
        publishedDate: DateTime(2023, 10, 24),
        categoryId: 2,
      ),
    ];
  }

  static List<Category> getCategories() {
    return [
      Category(id: 1, name: 'Flutter'),
      Category(id: 2, name: 'Dart'),
      Category(id: 3, name: 'Mobile Development'),
    ];
  }
}
''