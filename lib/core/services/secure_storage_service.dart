import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Instancia única del almacenamiento seguro
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences:
          true, // ✅ Usa almacenamiento cifrado en Android
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility
          .first_unlock, // ✅ Mantiene los datos tras reinicio
    ),
  );

  // Guarda valor cifrado
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Lee valor
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Borra un valor
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Limpia todo
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
