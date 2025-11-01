import '../entities/vehicle_entity.dart';
import '../entities/vehicle_catalog_entity.dart';

abstract class VehicleRepository {
  Future<List<VehicleTypeEntity>> getTypes();
  Future<List<VehicleBrandEntity>> getBrands();
  Future<List<VehicleColorEntity>> getColors();
  Future<VehicleEntity> registerVehicle(String driverUuid, int typeId, int brandId, int colorId);
}
