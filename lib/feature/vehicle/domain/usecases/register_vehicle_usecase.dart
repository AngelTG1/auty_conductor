import 'package:auty_conductor/core/services/secure_storage_service.dart';
import '../entities/vehicle_entity.dart';
import '../repositories/vehicle_repository.dart';

class RegisterVehicleUseCase {
  final VehicleRepository repo;
  RegisterVehicleUseCase(this.repo);

  /// 🔹 Ya no requiere `driverUuid` como parámetro,
  /// lo obtiene automáticamente desde el SecureStorage.
  Future<VehicleEntity> call(int typeId, int brandId, int colorId) async {
    // Leer desde almacenamiento seguro
    final driverUuid = await SecureStorageService.read('driverUuid');
    final userUuid = await SecureStorageService.read('userUuid');

    // Determinar cuál usar
    final uuidToUse = driverUuid?.isNotEmpty == true ? driverUuid : userUuid;

    if (uuidToUse == null || uuidToUse.isEmpty) {
      throw Exception("⚠️ No se encontró driverUuid ni userUuid guardado.");
    }

    print('✅ UUID usado para registrar vehículo: $uuidToUse');

    return repo.registerVehicle(uuidToUse, typeId, brandId, colorId);
  }
}
