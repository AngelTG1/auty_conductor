import 'package:auty_conductor/feature/location/presentation/widget/review_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/comment_provider.dart';

class CommentSection extends StatelessWidget {
  final String mechanicUuid;

  const CommentSection({super.key, required this.mechanicUuid});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommentProvider>();

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(18),
        child: Text("Este mecánico aún no tiene comentarios."),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: provider.comments.map((c) {
          return ReviewCard(
            name: c.driverName,
            comment: c.texto,
            rating: c.puntuacion,
            timeAgo: "Reciente",
            photoUrl: c.driverPhoto, // ⭐ AQUÍ EL CAMBIO
          );
        }).toList(),
      ),
    );
  }
}
