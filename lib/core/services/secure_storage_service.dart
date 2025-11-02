import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // Guarda valor cifrado
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Lee valor
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Borra uno
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Limpia todo
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
