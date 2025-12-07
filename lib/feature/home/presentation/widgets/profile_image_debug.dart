import 'package:flutter/material.dart';

class ProfileImageDebug extends StatelessWidget {
  final String? imageUrl;

  const ProfileImageDebug({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Mostrar la URL directamente en pantalla
        Text(
          "URL de imagen:",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          imageUrl ?? "NULL",
          style: const TextStyle(color: Colors.blue),
        ),
        const SizedBox(height: 10),

        // 🔹 Intentar mostrar la imagen
        ClipOval(
          child: SizedBox(
            width: 80,
            height: 80,
            child: imageUrl == null || imageUrl!.isEmpty
                ? Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.error, color: Colors.red),
                  )
                : Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image, color: Colors.red),
                      );
                    },
                  ),
          ),
        ),

        const SizedBox(height: 8),

        // 🔹 Mostrar errores en consola también
        TextButton(
          onPressed: () {
            debugPrint("🔥 DEBUG — URL recibida: $imageUrl");
          },
          child: const Text("Imprimir URL en consola"),
        ),
      ],
    );
  }
}
