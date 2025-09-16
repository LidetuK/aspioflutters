
import 'package:flutter/material.dart';
import 'package:myapp/models/post.dart';
import 'package:myapp/ui/widgets/post_card.dart';

class PostList extends StatelessWidget {
  final List<Post> posts;
  final String? title;

  const PostList({Key? key, required this.posts, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No posts found', style: TextStyle(fontSize: 18, color: Colors.grey)),
            Text('Check back later for new content', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
        ],
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostCard(post: posts[index]);
          },
        ),
      ],
    );
  }
}
