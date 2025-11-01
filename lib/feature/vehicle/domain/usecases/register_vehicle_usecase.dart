import '../entities/vehicle_entity.dart';
import '../repositories/vehicle_repository.dart';

class RegisterVehicleUseCase {
  final VehicleRepository repo;
  RegisterVehicleUseCase(this.repo);

  Future<VehicleEntity> call(String driverUuid, int typeId, int brandId, int colorId) {
    return repo.registerVehicle(driverUuid, typeId, brandId, colorId);
  }
}
