import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/services/secure_storage_service.dart';
import '../models/vehicle_catalog_model.dart';
import '../models/vehicle_model.dart';
import '../../domain/entities/vehicle_entity.dart';

class VehicleRemoteDataSource {
  final String baseUrl =
      'https://backauty-production.up.railway.app/API/v1/vehicles';

  // 🔹 Tipos
  Future<List<VehicleTypeModel>> getTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/vehicle-types'));
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => VehicleTypeModel.fromJson(e)).toList();
    }
    throw Exception('Error al obtener tipos de vehículo');
  }

  // 🔹 Marcas
  Future<List<VehicleBrandModel>> getBrands() async {
    final response = await http.get(Uri.parse('$baseUrl/vehicle-brands'));
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => VehicleBrandModel.fromJson(e)).toList();
    }
    throw Exception('Error al obtener marcas');
  }

  // 🔹 Colores
  Future<List<VehicleColorModel>> getColors() async {
    final response = await http.get(Uri.parse('$baseUrl/vehicle-colors'));
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => VehicleColorModel.fromJson(e)).toList();
    }
    throw Exception('Error al obtener colores');
  }

  // 🔹 Registrar vehículo (versión 100% segura)
  Future<VehicleModel> registerVehicle({
    required int typeId,
    required int brandId,
    required int colorId,
  }) async {
    final token = await SecureStorageService.read('token');
    final driverUuid = await SecureStorageService.read('driverUuid');
    final userUuid = await SecureStorageService.read('userUuid'); // respaldo

    // 🔍 Depuración
    print('🔐 Token leído: $token');
    print('🚗 DriverUuid leído: $driverUuid');
    print('👤 UserUuid leído: $userUuid');

    // 🔹 Validaciones
    if (token == null || token.isEmpty) {
      throw Exception(
        "⚠️ No se encontró token guardado. Debes iniciar sesión nuevamente.",
      );
    }

    // Si no hay driverUuid, usamos userUuid como respaldo (por si tu backend lo acepta)
    final uuidToUse = driverUuid?.isNotEmpty == true ? driverUuid : userUuid;

    if (uuidToUse == null || uuidToUse.isEmpty) {
      throw Exception("⚠️ No se encontró driverUuid ni userUuid guardado.");
    }

    // 🔹 Petición POST
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'driverUuid': uuidToUse,
        'typeId': typeId,
        'brandId': brandId,
        'colorId': colorId,
      }),
    );

    print('📡 POST ${response.request?.url} → ${response.statusCode}');
    print(
      '📦 BODY ENVIADO: ${jsonEncode({'driverUuid': uuidToUse, 'typeId': typeId, 'brandId': brandId, 'colorId': colorId})}',
    );
    print('📩 RESPUESTA: ${response.body}');

    if (response.statusCode == 201) {
      return VehicleModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Error al registrar vehículo',
      );
    }
  }

  // 🔹 Obtener vehículo actual
  Future<VehicleEntity?> getMyVehicle(String driverUuid) async {
    final token = await SecureStorageService.read('token');
    if (token == null) throw Exception("Token no encontrado");

    final response = await http.get(
      Uri.parse('$baseUrl/my/$driverUuid'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = jsonDecode(response.body);

      if (data is List && data.isNotEmpty) {
        // 🔹 Toma el más reciente
        final latest = data.first;
        return VehicleModel.fromJson(latest);
      }
    }
    return null;
  }
}
