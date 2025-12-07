import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/http/api_constants.dart';
import '../models/comment_model.dart';

class CommentRemoteDataSource {
  final String baseUrl = ApiConstants.comments;

  // 🔹 Guardar comentario
  Future<void> sendComment({
    required String texto,
    required String driverUuid,
    required String mechanicUuid,
  }) async {
    final url = Uri.parse("$baseUrl/sentimiento");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "texto": texto,
        "driver_uuid": driverUuid,
        "mechanic_uuid": mechanicUuid,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al guardar el comentario");
    }
  }

  // 🔹 Obtener comentarios de un mecánico
  Future<List<CommentModel>> getComments(String mechanicUuid) async {
    final url = Uri.parse("$baseUrl/comentarios/mecanico/$mechanicUuid");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Error al obtener comentarios");
    }

    final json = jsonDecode(response.body);

    final List data = json["comentarios"];

    return data.map((e) => CommentModel.fromJson(e)).toList();
  }
}
