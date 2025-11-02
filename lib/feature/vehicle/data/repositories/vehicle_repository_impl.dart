import '../../domain/entities/vehicle_entity.dart';
import '../../domain/entities/vehicle_catalog_entity.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_remote_datasource.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remote;

  VehicleRepositoryImpl(this.remote);

  @override
  Future<List<VehicleTypeEntity>> getTypes() => remote.getTypes();

  @override
  Future<List<VehicleBrandEntity>> getBrands() => remote.getBrands();

  @override
  Future<List<VehicleColorEntity>> getColors() => remote.getColors();

  @override
  Future<VehicleEntity> registerVehicle(
    String driverUuid,
    int typeId,
    int brandId,
    int colorId,
  ) {
    return remote.registerVehicle(
      typeId: typeId,
      brandId: brandId,
      colorId: colorId,
    );
  }

  // 🔹 Nuevo método
  Future<VehicleEntity?> getMyVehicle(String driverUuid) async {
    return remote.getMyVehicle(driverUuid);
  }
}
