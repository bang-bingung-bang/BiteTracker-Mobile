import 'package:bite_tracker_mobile/feature/sharebites/models/sharebites_data.dart';
import 'package:bite_tracker_mobile/feature/sharebites/screens/create_sharebites.dart';
import 'package:bite_tracker_mobile/feature/sharebites/widgets/sharebites_card.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShareBitesScreen extends StatefulWidget {
  const ShareBitesScreen({super.key});

  @override
  State<ShareBitesScreen> createState() => _ShareBitesScreenState();
}

class _ShareBitesScreenState extends State<ShareBitesScreen> {
  Future<List<ShareBites>> fetchShareBites(CookieRequest request) async {
    // Make sure to include trailing slash
    final response = await request.get('http://localhost:8000/sharebites/json/');
    
    // Convert response to ShareBites objects
    List<ShareBites> listShareBites = [];
    for (var d in response) {
      if (d != null) {
        listShareBites.add(ShareBites.fromJson(d));
      }
    }
    return listShareBites;
  }

  // DELETE request using http package
  Future<void> deletePost(int postId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8000/sharebites/post/$postId/delete/'),
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Deleted successfully'),
          ),
        );
        setState(() {}); // Refresh the UI after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete post'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete post: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ShareBites',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: fetchShareBites(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'No posts available in ShareBites.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF533A2E),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index]; // Define 'post' here
                  return ShareBitesCard(
                    post: post,
                    onDelete: () {
                      deletePost(post.pk); // Pass post.pk here to delete the post
                    },
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateShareBitesScreen(),
            ),
          ).then((_) => setState(() {}));
        },
        backgroundColor: const Color(0xFF533A2E),
        child: const Icon(Icons.add),
      ),
    );
  }
}
