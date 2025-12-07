import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/http/api_constants.dart';
import '../models/chat_message_model.dart';

class ChatRemoteDataSource {
  final String url = "${ApiConstants.baseUrl}/API/v1/m/chat";

  Future<ChatMessageModel> sendMessage(Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse("$url/send"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final json = jsonDecode(res.body);

    if (res.statusCode == 201) {
      return ChatMessageModel.fromJson(json);
    }

    throw Exception(json["error"] ?? "Error enviando mensaje");
  }

  Future<List<ChatMessageModel>> getMessages(String chatUuid) async {
    final res = await http.get(Uri.parse("$url/$chatUuid"));

    final json = jsonDecode(res.body);

    if (res.statusCode == 200) {
      // ⭐ NUEVO → backend ahora devuelve { messages: [...] }
      final list = json["messages"] as List;

      return list.map((e) => ChatMessageModel.fromJson(e)).toList();
    }

    throw Exception(json["error"] ?? "Error obteniendo mensajes");
  }
}
