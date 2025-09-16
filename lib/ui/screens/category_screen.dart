
import 'package:flutter/material.dart';
import 'package:myapp/models/post.dart';
import 'package:myapp/services/wordpress_api.dart';
import 'package:myapp/ui/widgets/category_list.dart';
import 'package:myapp/ui/widgets/post_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int? _selectedCategoryId;
  List<Post> _posts = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final categories = await WordPressApiService.fetchAllCategories();
      final posts = await WordPressApiService.fetchAllPostsForSearch();
      
      setState(() {
        _categories = categories;
        _posts = posts;
        _selectedCategoryId = categories.isNotEmpty ? categories.first.id : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Categories')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Categories')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final List<Post> filteredPosts = _selectedCategoryId == null
        ? _posts
        : _posts.where((post) => post.category.id == _selectedCategoryId).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: CategoryList(
                categories: _categories,
                selectedCategory: _selectedCategoryId != null 
                    ? _categories.firstWhere((cat) => cat.id == _selectedCategoryId).slug
                    : null,
                onCategorySelected: _onCategorySelected,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: PostList(
                posts: filteredPosts,
                title: _selectedCategoryId != null 
                    ? 'Posts in ${_categories.firstWhere((cat) => cat.id == _selectedCategoryId).name}'
                    : 'All Posts',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
