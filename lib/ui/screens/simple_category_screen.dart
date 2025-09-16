import 'package:flutter/material.dart';
import 'package:myapp/models/post.dart';
import 'package:myapp/services/wordpress_api.dart';
import 'package:myapp/ui/widgets/cors_image.dart';
import 'package:myapp/ui/screens/post_detail_screen.dart';

class SimpleCategoryScreen extends StatefulWidget {
  const SimpleCategoryScreen({super.key});

  @override
  State<SimpleCategoryScreen> createState() => _SimpleCategoryScreenState();
}

class _SimpleCategoryScreenState extends State<SimpleCategoryScreen> {
  bool isLoading = true;
  String? error;
  List<Category> categories = [];
  List<Post> posts = [];
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      print('Loading categories and posts...');
      
      // Load categories and posts in parallel
      final results = await Future.wait([
        WordPressApiService.fetchAllCategories().timeout(const Duration(seconds: 15)),
        WordPressApiService.fetchAllPosts(perPage: 10).timeout(const Duration(seconds: 15)),
      ]);
      
      final fetchedCategories = results[0] as List<Category>;
      final fetchedPosts = results[1] as List<Post>;
      
      print('Fetched ${fetchedCategories.length} categories, ${fetchedPosts.length} posts');
      
      setState(() {
        categories = fetchedCategories;
        posts = fetchedPosts;
        isLoading = false;
      });
      
      print('Data loaded successfully');
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        error = 'Failed to load data. Please check your internet connection.';
        isLoading = false;
      });
    }
  }

  void _onCategorySelected(int categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });
  }

  List<Post> get filteredPosts {
    if (selectedCategoryId == null) {
      return posts;
    }
    return posts.where((post) => post.category.id == selectedCategoryId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    // Categories List
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey[100],
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected = selectedCategoryId == category.id;
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: isSelected ? Colors.blue[50] : Colors.white,
                              child: ListTile(
                                title: Text(
                                  category.name,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Colors.blue[700] : Colors.black,
                                  ),
                                ),
                                subtitle: Text('${category.postCount} posts'),
                                onTap: () => _onCategorySelected(category.id),
                                selected: isSelected,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Posts List
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedCategoryId == null
                                  ? 'All Posts'
                                  : 'Posts in ${categories.firstWhere((cat) => cat.id == selectedCategoryId).name}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: _loadData,
                                child: ListView.builder(
                                  itemCount: filteredPosts.length,
                                  itemBuilder: (context, index) {
                                    final post = filteredPosts[index];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PostDetailScreen(post: post),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Featured Image
                                            if (post.featuredImage.isNotEmpty)
                                              ClipRRect(
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                                child: CORSImage(
                                                  imageUrl: post.featuredImage,
                                                  height: 150,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            // Content
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    post.title,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    post.excerpt,
                                                    style: const TextStyle(color: Colors.grey),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor: Colors.blue[100],
                                                        child: Text(
                                                          post.author.name.isNotEmpty 
                                                              ? post.author.name[0].toUpperCase()
                                                              : 'A',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.blue[700],
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        post.author.name,
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                      const Spacer(),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: Colors.blue[50],
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Text(
                                                          post.category.name,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.blue[700],
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
