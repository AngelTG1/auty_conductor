import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/http/api_constants.dart';
import '../models/auth_model.dart';

class AuthRemoteDataSource {
  final String baseUrl = ApiConstants.auth;

  // ===============================
  // 🔹 LOGIN NORMAL (CON appType)
  // ===============================
  Future<AuthModel> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'appType': 'driver', // 👈 IMPORTANTE PARA ESTA APP
      }),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthModel.fromJson(json);
    } else {
      throw Exception(json['message'] ?? 'Error de autenticación');
    }
  }

  // ===============================
  // 🔹 REGISTER NORMAL (driver)
  // ===============================
  Future<AuthModel> register(
    String name,
    String phone,
    String email,
    String password,
    bool isDriver,
  ) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'confirmPassword': password,
        'isDriver': isDriver,
      }),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return AuthModel.fromJson(json);
    } else {
      throw Exception(json['message'] ?? 'Error al registrar usuario');
    }
  }

  // ===============================
  // 🔥 LOGIN CON GOOGLE (SIMPLE)
  // ===============================
  Future<AuthModel> loginWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    if (gUser == null) throw Exception("Inicio de sesión cancelado");

    final gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (idToken == null) {
      throw Exception("No se pudo obtener el ID Token de Firebase");
    }

    final url = Uri.parse('$baseUrl/google');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Error en inicio con Google');
    }
  }
}
