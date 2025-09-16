
import 'package:flutter/material.dart';
import 'package:myapp/models/post.dart';
import 'package:myapp/services/wordpress_api.dart';
import 'package:myapp/ui/widgets/post_list.dart';
import 'package:myapp/ui/widgets/search_bar.dart' as custom;
import 'package:myapp/ui/widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> posts = [];
  List<Post> allPosts = []; // For search
  List<Post> displayedPosts = [];
  List<Post> filteredPosts = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  String? error;
  String searchQuery = '';
  int currentPage = 1;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    // Add a small delay to prevent immediate loading issues
    Future.delayed(const Duration(milliseconds: 100), () {
      _loadPosts();
    });
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      print('Starting to fetch posts...');
      
      // Add timeout to prevent hanging
      final fetchedPosts = await WordPressApiService.fetchAllPosts(perPage: 2)
          .timeout(const Duration(seconds: 15));
      
      print('Fetched ${fetchedPosts.length} posts');
      
      setState(() {
        posts = fetchedPosts;
        allPosts = fetchedPosts; // Use same data for search initially
        displayedPosts = fetchedPosts;
        filteredPosts = fetchedPosts;
        hasMore = false; // Start with no more posts
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
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
      
      final nextPage = currentPage + 1;
      final postsPerPage = 2;
      final startIndex = currentPage * postsPerPage;
      final endIndex = startIndex + postsPerPage;
      
      final newPosts = allPosts.skip(startIndex).take(postsPerPage).toList();
      
      if (newPosts.isNotEmpty) {
        setState(() {
          displayedPosts.addAll(newPosts);
          filteredPosts = displayedPosts;
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
        filteredPosts = displayedPosts;
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
                    custom.SearchBar(onSearch: _onSearch),
                    if (searchQuery.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Found ${filteredPosts.length} posts for "$searchQuery"',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
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
                                  
                                  return PostCard(post: filteredPosts[index]);
                                },
                              ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
