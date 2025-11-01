import '../entities/vehicle_catalog_entity.dart';
import '../repositories/vehicle_repository.dart';

/// Caso de uso para obtener los catálogos de vehículos:
/// - Tipos
/// - Marcas
/// - Colores
class GetVehicleCatalogUseCase {
  final VehicleRepository repository;

  GetVehicleCatalogUseCase(this.repository);

  /// 🔹 Obtiene todos los tipos de vehículo (sedán, pickup, etc.)
  Future<List<VehicleTypeEntity>> getTypes() async {
    return await repository.getTypes();
  }

  /// 🔹 Obtiene todas las marcas (Toyota, Ford, etc.)
  Future<List<VehicleBrandEntity>> getBrands() async {
    return await repository.getBrands();
  }

  /// 🔹 Obtiene todos los colores (rojo, gris, azul, etc.)
  Future<List<VehicleColorEntity>> getColors() async {
    return await repository.getColors();
  }

  /// 🔹 Si deseas cargar todo de una vez (opcional)
  Future<Map<String, dynamic>> getAllCatalogs() async {
    final types = await repository.getTypes();
    final brands = await repository.getBrands();
    final colors = await repository.getColors();

    return {
      "types": types,
      "brands": brands,
      "colors": colors,
    };
  }
}
