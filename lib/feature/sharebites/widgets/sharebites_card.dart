// lib/feature/sharebites/widgets/sharebites_card.dart

import 'package:bite_tracker_mobile/feature/sharebites/models/sharebites_data.dart';
import 'package:flutter/material.dart';


class ShareBitesCard extends StatelessWidget {
  final ShareBites post;
  final VoidCallback onDelete;

  const ShareBitesCard({
    super.key,
    required this.post,
    required this.onDelete,
  });

  Color _getTagColor(String type, String value) {
    switch (type) {
      case 'calorie':
        return value == 'low' ? const Color(0xFFECC424) : const Color(0xFFE0191C);
      case 'sugar':
        return value == 'low' ? const Color(0xFF16B8E1) : const Color(0xFF2424EC);
      case 'diet':
        return value == 'vegan' ? const Color(0xFF259B21) : const Color(0xFF55F050);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFF533A2E), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              post.fields.image,
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
                        post.fields.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                      color: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag('calorie', post.fields.calorieContent),
                    _buildTag('sugar', post.fields.sugarContent),
                    _buildTag('diet', post.fields.dietType),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  post.fields.content,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                Text(
                  'Posted at: ${post.fields.createdAt.toString()}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String type, String value) {
    String displayText = '';
    switch (type) {
      case 'calorie':
        displayText = '${value.capitalize()} Calorie';
        break;
      case 'sugar':
        displayText = '${value.capitalize()} Sugar';
        break;
      case 'diet':
        displayText = value.capitalize();
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getTagColor(type, value),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: type == 'diet' && value == 'non-vegan' 
              ? Colors.black 
              : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}