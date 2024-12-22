import 'package:bite_tracker_mobile/feature/main/pages/menu.dart';
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
    final response = await request.get('http://localhost:8000/sharebites/json/');
    List<ShareBites> listShareBites = [];
    for (var d in response) {
      if (d != null) {
        listShareBites.add(ShareBites.fromJson(d));
      }
    }
    return listShareBites;
  }

  Future<void> deletePost(int postId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8000/sharebites/post/$postId/delete/'),
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deleted successfully')),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete post')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      // Mengubah AppBar dengan background hitam
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Ikon back
          color: Colors.white,                // Warna ikon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          },
        ),
        title: const Text(
          'ShareBites',
          style: TextStyle(
            color: Colors.white,  // Mengubah warna teks menjadi putih
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFF533A2E),  // Mengubah background menjadi hitam
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),  // Mengubah warna ikon menjadi putih
      ),
      body: Column(
        children: [
          // Header section dengan background putih
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            color: Colors.white,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calling all BiteTracker fellows! Show off your favorite eats and inspire others with your delicious finds! 🍽️',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // List of posts
          Expanded(
            child: FutureBuilder(
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
                        final post = snapshot.data![index];
                        return ShareBitesCard(
                          post: post,
                          onDelete: () => deletePost(post.pk),
                          currentUserId: 2,
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
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
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}