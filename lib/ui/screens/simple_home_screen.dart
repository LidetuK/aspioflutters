import 'package:flutter/material.dart';
import 'package:myapp/models/post.dart';
import 'package:myapp/services/wordpress_api.dart';
import 'package:myapp/ui/widgets/cors_image.dart';
import 'package:myapp/ui/screens/post_detail_screen.dart';

class SimpleHomeScreen extends StatefulWidget {
  const SimpleHomeScreen({super.key});

  @override
  State<SimpleHomeScreen> createState() => _SimpleHomeScreenState();
}

class _SimpleHomeScreenState extends State<SimpleHomeScreen> {
  bool isLoading = true;
  String? error;
  List<Post> posts = [];
  List<Post> allPosts = [];
  List<Post> filteredPosts = [];
  String searchQuery = '';
  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      print('Loading posts from WordPress...');
      
      // Load initial posts
      final fetchedPosts = await WordPressApiService.fetchAllPosts(perPage: 2)
          .timeout(const Duration(seconds: 15));
      
      // Load all posts for search
      final allFetchedPosts = await WordPressApiService.fetchAllPostsForSearch()
          .timeout(const Duration(seconds: 15));
      
      print('Fetched ${fetchedPosts.length} initial posts, ${allFetchedPosts.length} total posts');
      
      setState(() {
        posts = fetchedPosts;
        allPosts = allFetchedPosts;
        filteredPosts = fetchedPosts;
        hasMore = allFetchedPosts.length > fetchedPosts.length;
        isLoading = false;
      });
      
      print('Posts loaded successfully');
    } catch (e) {
      print('Error loading posts: $e');
      setState(() {
        error = 'Failed to load posts. Please check your internet connection.';
        isLoading = false;
      });
    }
  }

  Future<void> _loadMorePosts() async {
    if (isLoadingMore || !hasMore || searchQuery.isNotEmpty) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final nextPage = currentPage + 1;
      final postsPerPage = 2;
      final startIndex = currentPage * postsPerPage;
      final endIndex = startIndex + postsPerPage;
      
      final newPosts = allPosts.skip(startIndex).take(postsPerPage).toList();
      
      if (newPosts.isNotEmpty) {
        setState(() {
          posts.addAll(newPosts);
          filteredPosts = posts;
          currentPage = nextPage;
          hasMore = endIndex < allPosts.length;
        });
      } else {
        setState(() {
          hasMore = false;
        });
      }
    } catch (e) {
      print('Error loading more posts: $e');
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredPosts = posts;
      } else {
        filteredPosts = allPosts.where((post) {
          return post.title.toLowerCase().contains(query.toLowerCase()) ||
                 post.excerpt.toLowerCase().contains(query.toLowerCase()) ||
                 post.category.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlogSpace'),
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
                        onPressed: _loadPosts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        onChanged: _onSearch,
                        decoration: InputDecoration(
                          hintText: 'Search posts...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    // Search results info
                    if (searchQuery.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Found ${filteredPosts.length} posts for "$searchQuery"',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    // Posts List
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadPosts,
                        child: filteredPosts.isEmpty && searchQuery.isNotEmpty
                            ? const Center(
                                child: Text('No posts found for your search'),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: filteredPosts.length + (hasMore && searchQuery.isEmpty ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == filteredPosts.length) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Center(
                                        child: ElevatedButton(
                                          onPressed: isLoadingMore ? null : _loadMorePosts,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: isLoadingMore
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  ),
                                                )
                                              : const Text(
                                                  'Load More Posts',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                ),
                                        ),
                                      ),
                                    );
                                  }
                                  
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
                                                height: 200,
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
    );
  }
}
