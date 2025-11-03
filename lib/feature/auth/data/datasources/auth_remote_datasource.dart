import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_model.dart';

class AuthRemoteDataSource {
  final String baseUrl =
      'https://backauty-production.up.railway.app/API/v1/auth'; 

  Future<AuthModel> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthModel.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Error de autenticación');
    }
  }
}
