import 'package:flutter/material.dart';
import 'package:auty_conductor/core/services/secure_storage_service.dart';

/// 🔹 Proveedor global para mantener sincronizados los datos del usuario
class UserProvider extends ChangeNotifier {
  String? uuid;
  String? name;
  String? email;
  String? phone;
  String? licenseNumber;

  bool _initialized = false;
  bool get initialized => _initialized;

  /// 🔹 Carga los datos desde el almacenamiento seguro
  Future<void> loadFromStorage() async {
    uuid = await SecureStorageService.read('userUuid');
    name = await SecureStorageService.read('userName');
    email = await SecureStorageService.read('userEmail');
    phone = await SecureStorageService.read('userPhone');
    licenseNumber = await SecureStorageService.read('userLicense');
    _initialized = true;
    notifyListeners();
  }

  /// 🔹 Actualiza datos y los guarda en almacenamiento seguro
  Future<void> updateUser({
    String? uuid,
    String? name,
    String? email,
    String? phone,
    String? licenseNumber,
  }) async {
    if (uuid != null) this.uuid = uuid;
    if (name != null) this.name = name;
    if (email != null) this.email = email;
    if (phone != null) this.phone = phone;
    if (licenseNumber != null) this.licenseNumber = licenseNumber;

    if (uuid != null) await SecureStorageService.write('userUuid', uuid);
    if (name != null) await SecureStorageService.write('userName', name);
    if (email != null) await SecureStorageService.write('userEmail', email);
    if (phone != null) await SecureStorageService.write('userPhone', phone);
    if (licenseNumber != null) {
      await SecureStorageService.write('userLicense', licenseNumber);
    }

    notifyListeners();
  }

  /// 🔹 Limpia datos del usuario
  Future<void> clear() async {
    uuid = null;
    name = null;
    email = null;
    phone = null;
    licenseNumber = null;
    _initialized = false;
    await SecureStorageService.clear();
    notifyListeners();
  }
}
