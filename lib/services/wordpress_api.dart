import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class WordPressApiService {
  static const String baseUrl = 'https://elfignentertainment.com/aspio/wp-json/wp/v2';
  
  // Fetch all posts
  static Future<List<Post>> fetchAllPosts({int page = 1, int perPage = 6}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts?_embed=true&per_page=$perPage&page=$page&orderby=date&order=desc'),
        headers: {'User-Agent': 'Flutter Blog App'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) {
          try {
            return Post.fromJson(json);
          } catch (e) {
            print('Error parsing post: $e');
            return null;
          }
        }).where((post) => post != null).cast<Post>().toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  // Fetch all posts for search (more posts)
  static Future<List<Post>> fetchAllPostsForSearch() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts?_embed=true&per_page=100&orderby=date&order=desc'),
        headers: {'User-Agent': 'Flutter Blog App'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) {
          try {
            return Post.fromJson(json);
          } catch (e) {
            print('Error parsing post: $e');
            return null;
          }
        }).where((post) => post != null).cast<Post>().toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  // Fetch single post by slug
  static Future<Post?> fetchPostBySlug(String slug) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts?slug=$slug&_embed=true'),
        headers: {'User-Agent': 'Flutter Blog App'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        if (jsonData.isNotEmpty) {
          return Post.fromJson(jsonData[0]);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching post: $e');
      return null;
    }
  }

  // Fetch all categories
  static Future<List<Category>> fetchAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories?per_page=100'),
        headers: {'User-Agent': 'Flutter Blog App'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) {
          try {
            return Category.fromJson(json);
          } catch (e) {
            print('Error parsing category: $e');
            return null;
          }
        }).where((category) => category != null).cast<Category>().toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Fetch posts by category
  static Future<List<Post>> fetchPostsByCategory(int categoryId, {int page = 1, int perPage = 6}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts?categories=$categoryId&_embed=true&per_page=$perPage&page=$page&orderby=date&order=desc'),
        headers: {'User-Agent': 'Flutter Blog App'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posts by category: $e');
      return [];
    }
  }
}
