import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/comment_provider.dart';
import '../../../../core/services/secure_storage_service.dart';

class CommentModal {
  static void show(BuildContext context, String mechanicUuid) {
    final parentContext = context;
    final TextEditingController commentCtrl = TextEditingController();
    double rating = 3.0;
    bool sending = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              // ✅ Hace que el modal suba con el teclado
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.45,
                maxChildSize: 0.9,
                expand: false,
                builder: (context, scrollController) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // ✅ Cierra el teclado al tocar fuera
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 20,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(26),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 Indicador superior
                            Center(
                              child: Container(
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            const Center(
                              child: Text(
                                "Escribe tu reseña",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Center(
                              child: Text(
                                "Tu opinión nos ayuda a mejorar",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ⭐ RATING
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                final starIndex = index + 1;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() =>
                                        rating = starIndex.toDouble());
                                  },
                                  child: AnimatedScale(
                                    scale:
                                        starIndex == rating ? 1.2 : 1.0,
                                    duration:
                                        const Duration(milliseconds: 150),
                                    child: Icon(
                                      starIndex <= rating
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      size: 36,
                                      color: Colors.amber,
                                    ),
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 24),

                            // 📝 Comentario
                            TextField(
                              controller: commentCtrl,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText:
                                    "Cuéntanos tu experiencia...",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // ✅ BOTÓN CON LOADING
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: sending
                                    ? null
                                    : () async {
                                        final texto =
                                            commentCtrl.text.trim();

                                        if (texto.isEmpty) {
                                          ScaffoldMessenger.of(
                                            parentContext,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Debes escribir un comentario",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        final driverUuid =
                                            await SecureStorageService
                                                .read("driverUuid");

                                        if (driverUuid == null ||
                                            driverUuid.isEmpty) {
                                          ScaffoldMessenger.of(
                                            parentContext,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "No se pudo obtener el driverUuid",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        setState(() => sending = true);

                                        final provider = parentContext
                                            .read<CommentProvider>();

                                        await provider.sendComment(
                                          texto,
                                          driverUuid,
                                          mechanicUuid,
                                        );

                                        setState(
                                            () => sending = false);

                                        Navigator.pop(parentContext);

                                        ScaffoldMessenger.of(
                                          parentContext,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Comentario enviado 💙",
                                            ),
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF1E329D),
                                  padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(18),
                                  ),
                                  elevation: 3,
                                ),
                                child: sending
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child:
                                            CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Text(
                                        "Enviar comentario",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
