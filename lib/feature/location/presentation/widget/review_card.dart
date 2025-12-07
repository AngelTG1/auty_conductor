import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String comment;
  final double rating;
  final String timeAgo;
  final dynamic photoUrl; // 🔥 puede ser String o Map

  const ReviewCard({
    super.key,
    required this.name,
    required this.comment,
    required this.rating,
    required this.timeAgo,
    this.photoUrl,
  });

  String _safeImageUrl(dynamic photo) {
    if (photo == null) return "";

    if (photo is Map && photo.containsKey("value")) {
      return photo["value"] ?? "";
    }

    if (photo is String) {
      return photo;
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  _safeImageUrl(photoUrl),
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE5E5E5),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 26,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            comment,
            style: const TextStyle(
              fontSize: 14,
              height: 1.3,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
