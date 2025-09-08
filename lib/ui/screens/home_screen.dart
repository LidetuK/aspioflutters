
import 'package:flutter/material.dart';
import 'package:myapp/models/post.dart';
import 'package:myapp/services/mock_data_service.dart';
import 'package:myapp/ui/widgets/post_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Post> posts = MockDataService.getPosts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: PostList(posts: posts),
    );
  }
}
