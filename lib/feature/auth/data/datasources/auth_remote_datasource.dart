import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/http/api_constants.dart'; // 👈 Importa el archivo
import '../models/auth_model.dart';

class AuthRemoteDataSource {
  final String baseUrl = ApiConstants.auth;

  // 🔹 Login normal
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

  // 🔹 Registro normal con isDriver
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
        'isDriver': isDriver, // ✅ ahora enviamos el rol al backend
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return AuthModel.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Error al registrar usuario');
    }
  }

  // 🔹 Login con Google
  Future<AuthModel> loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception('Inicio de sesión cancelado');

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (idToken == null) throw Exception('Error obteniendo ID Token');

    final url = Uri.parse('$baseUrl/google');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthModel.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
        error['message'] ?? 'Error en inicio de sesión con Google',
      );
    }
  }
}
