
import 'package:flutter/material.dart';
import 'package:myapp/models/category.dart';
import 'package:myapp/models/post.dart';
import 'package:myapp/services/mock_data_service.dart';
import 'package:myapp/ui/widgets/category_list.dart';
import 'package:myapp/ui/widgets/post_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int? _selectedCategoryId;
  late List<Post> _posts;
  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _posts = MockDataService.getPosts();
    _categories = MockDataService.getCategories();
    _selectedCategoryId = _categories.isNotEmpty ? _categories.first.id : null;
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Post> filteredPosts = _selectedCategoryId == null
        ? _posts
        : _posts.where((post) => post.categoryId == _selectedCategoryId).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Column(
        children: [
          CategoryList(
            categories: _categories,
            onCategorySelected: _onCategorySelected,
          ),
          Expanded(
            child: PostList(posts: filteredPosts),
          ),
        ],
      ),
    );
  }
}
