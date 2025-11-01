import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vehicle_catalog_model.dart';
import '../models/vehicle_model.dart';

class VehicleRemoteDataSource {
  final String baseUrl = 'http://192.168.0.19:3000/API/v1/vehicles';

  Future<List<VehicleTypeModel>> getTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/vehicle-types'));
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => VehicleTypeModel.fromJson(e)).toList();
    }
    throw Exception('Error al obtener tipos de vehículo');
  }

  Future<List<VehicleBrandModel>> getBrands() async {
    final response = await http.get(Uri.parse('$baseUrl/vehicle-brands'));
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => VehicleBrandModel.fromJson(e)).toList();
    }
    throw Exception('Error al obtener marcas');
  }

  Future<List<VehicleColorModel>> getColors() async {
    final response = await http.get(Uri.parse('$baseUrl/vehicle-colors'));
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => VehicleColorModel.fromJson(e)).toList();
    }
    throw Exception('Error al obtener colores');
  }

  Future<VehicleModel> registerVehicle({
    required int typeId,
    required int brandId,
    required int colorId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final driverUuid = prefs.getString('driverUuid'); // ✅ CORRECTO

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'driverUuid': driverUuid, // 👈 CORRECTO
        'typeId': typeId,
        'brandId': brandId,
        'colorId': colorId,
      }),
    );

    if (response.statusCode == 201) {
      return VehicleModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Error al registrar vehículo');
    }
  }
}
