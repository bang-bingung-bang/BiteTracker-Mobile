import 'dart:convert';
import 'package:bite_tracker_mobile/feature/sharebites/models/sharebites_data.dart';
import 'package:bite_tracker_mobile/feature/sharebites/models/sharebites_comment_data.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ShareBitesCard extends StatefulWidget {
  final ShareBites post;
  final VoidCallback onDelete;
  final int currentUserId;

  const ShareBitesCard({
    super.key,
    required this.post,
    required this.onDelete, 
    required this.currentUserId,
  });

  @override
  State<ShareBitesCard> createState() => _ShareBitesCardState();
}

class _ShareBitesCardState extends State<ShareBitesCard> {
  final TextEditingController _commentController = TextEditingController();
  List<CommentData> comments = [];
  bool isLoading = true;
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    fetchComments();
    fetchLikeStatus();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> fetchLikeStatus() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
        'https://faiz-akram-bitetrackers.pbp.cs.ui.ac.id/sharebites/post/${widget.post.pk}/like-status/?user_id=${widget.currentUserId}',
      );
      
      if (mounted && response['status'] == 'success') {
        setState(() {
          isLiked = response['is_liked'];
          likeCount = response['likes_count'];
        });
      }
    } catch (e) {
      print('Error fetching like status: $e');
    }
  }

  Future<void> toggleLike() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.postJson(
        'https://faiz-akram-bitetrackers.pbp.cs.ui.ac.id/sharebites/post/${widget.post.pk}/like-toggle/',
        jsonEncode({
          'user_id': widget.currentUserId,
        }),
      );

      if (mounted && response['status'] == 'success') {
        setState(() {
          isLiked = response['liked'];
          likeCount = response['likes_count'];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update like')),
        );
      }
    }
  }

  Future<void> fetchComments() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
        'https://faiz-akram-bitetrackers.pbp.cs.ui.ac.id/sharebites/post/${widget.post.pk}/comments/get/',
      );
      
      if (mounted) {
        setState(() {
          comments = (response as List)
              .map((data) => CommentData.fromJson(data))
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final request = context.read<CookieRequest>();
    try {
      final response = await request.postJson(
        'https://faiz-akram-bitetrackers.pbp.cs.ui.ac.id/sharebites/post/${widget.post.pk}/comments/add/',
        jsonEncode({
          'content': _commentController.text.trim(),
          'user_id': 2, // Sesuaikan dengan user_id yang login
        }),
      );

      if (response['status'] == 'success') {
        _commentController.clear();
        fetchComments(); // Refresh comments
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Comment added successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey, width: 0.5),
      ),
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  widget.post.fields.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.post.fields.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Add like button and count here
                        Row(
                          children: [
                            InkWell(
                              onTap: toggleLike,
                              child: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? Colors.red : Colors.grey,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$likeCount',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        // Calorie Content Tag
                        if (widget.post.fields.calorieContent == 'low')
                          _buildTag('Low Calorie', const Color(0xFFECC424))
                        else if (widget.post.fields.calorieContent == 'high')
                          _buildTag('High Calorie', const Color(0xFFE0191C)),

                        // Sugar Content Tag
                        if (widget.post.fields.sugarContent == 'low')
                          _buildTag('Low Sugar', const Color(0xFF16B8E1))
                        else if (widget.post.fields.sugarContent == 'high')
                          _buildTag('High Sugar', const Color(0xFF2424EC)),

                        // Diet Type Tag
                        if (widget.post.fields.dietType == 'vegan')
                          _buildTag('Vegan', const Color(0xFF259B21))
                        else if (widget.post.fields.dietType == 'non-vegan')
                          _buildTag('Non-Vegan', const Color(0xFF55F050), textColor: Colors.black),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.post.fields.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Posted at: ${_formatDateTime(widget.post.fields.createdAt)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Comments Section
                    const Text(
                      'Comments:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (comments.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'No comments yet.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.content,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Posted by: ${comment.user}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 16),
                    // Add comment input field
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Type a comment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: addComment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0095FF),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16),
                            elevation: 2,
                          ),
                          child: const Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Delete button
          if (widget.post.fields.user == widget.currentUserId) // Tampilkan hanya jika user adalah pembuat post
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: widget.onDelete,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color, {Color textColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,  // Menggunakan parameter textColor
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day} ${_getMonth(dateTime.month)} ${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}