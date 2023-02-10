import 'package:flutter/material.dart';

class PostDetailsPage extends StatelessWidget {
  final String postId;

  const PostDetailsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Post details page: $postId"),
    );
  }
}
