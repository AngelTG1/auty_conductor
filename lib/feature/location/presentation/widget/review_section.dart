import 'package:flutter/material.dart';
import 'review_card.dart';

class ReviewSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const ReviewSection({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado: "Reviews" + "See All"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Reseñas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              TextButton(
                onPressed: () {},
                child: const Text(
                  "Ver todos",
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Lista de reviews
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: reviews.map((r) {
              return ReviewCard(
                name: r["name"],
                comment: r["comment"],
                rating: r["rating"],
                timeAgo: r["timeAgo"],
                photoUrl: r["photoUrl"], // 🔥 NUEVO
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
