import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/secure_storage_service.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/http/api_constants.dart';

class SelectRolePage extends StatelessWidget {
  final String userUuid;
  const SelectRolePage({super.key, required this.userUuid});

  Future<void> updateRole(BuildContext context, bool isDriver) async {
    final url = Uri.parse('${ApiConstants.auth}/set-role');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'uuid': userUuid, 'isDriver': isDriver}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Si el usuario confirmó que es conductor
        if (isDriver && data['driver'] != null) {
          final driver = data['driver'];
          final driverUuid = driver['uuid'] ?? '';
          await SecureStorageService.write('driverUuid', driverUuid);
          debugPrint('🚗 Nuevo driverUuid guardado: $driverUuid');
        }

        // ✅ Guarda flag de rol
        await SecureStorageService.write('isDriver', isDriver.toString());

        // 🔹 Redirige al flujo correcto
        if (!context.mounted) return;
        context.go(AppRoutes.vehicleType);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Error actualizando el rol');
      }
    } catch (e) {
      debugPrint('❌ Error en updateRole: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Confirmar rol'),
        backgroundColor: const Color(0xFF1E329D),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Confirma que eres conductor',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E329D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => updateRole(context, true),
                icon: const Icon(Icons.directions_car, color: Colors.white),
                label: const Text(
                  'Confirmar conductor',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E329D),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
