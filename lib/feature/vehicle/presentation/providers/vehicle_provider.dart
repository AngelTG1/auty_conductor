import 'package:flutter/material.dart';
import 'package:auty_conductor/feature/vehicle/data/datasources/vehicle_remote_datasource.dart';
import 'package:auty_conductor/feature/vehicle/data/repositories/vehicle_repository_impl.dart';
import 'package:auty_conductor/feature/vehicle/domain/entities/vehicle_catalog_entity.dart';
import 'package:auty_conductor/feature/vehicle/domain/entities/vehicle_entity.dart';
import 'package:auty_conductor/feature/vehicle/domain/usecases/register_vehicle_usecase.dart';

class VehicleProvider extends ChangeNotifier {
  final _repo = VehicleRepositoryImpl(VehicleRemoteDataSource());

  // 🔹 Catálogos
  List<VehicleTypeEntity> types = [];
  List<VehicleBrandEntity> brands = [];
  List<VehicleColorEntity> colors = [];

  // 🔹 Selecciones
  int? selectedTypeId;
  int? selectedBrandId;
  int? selectedColorId;
  VehicleEntity? currentVehicle;

  bool loading = false;

  // 🔹 Cargar catálogos
  Future<void> loadCatalogs() async {
    loading = true;
    notifyListeners();

    types = await _repo.getTypes();
    brands = await _repo.getBrands();
    colors = await _repo.getColors();

    loading = false;
    notifyListeners();
  }

  // 🔹 Seleccionar o deseleccionar tipo
  void selectType(int? id) {
    selectedTypeId = id;
    notifyListeners();
  }

  // 🔹 Seleccionar o deseleccionar marca
  void selectBrand(int? id) {
    selectedBrandId = id;
    notifyListeners();
  }

  // 🔹 Seleccionar o deseleccionar color
  void selectColor(int? id) {
    selectedColorId = id;
    notifyListeners();
  }

  // 🔹 Registrar vehículo
  Future<void> registerVehicle() async {
    if (selectedTypeId == null ||
        selectedBrandId == null ||
        selectedColorId == null) {
      throw Exception("Debes seleccionar tipo, marca y color");
    }

    final usecase = RegisterVehicleUseCase(_repo);
    await usecase.call(selectedTypeId!, selectedBrandId!, selectedColorId!);

    print('🚗 Vehículo registrado correctamente');
  }

  // 🔹 Obtener vehículo actual del conductor
  Future<void> loadCurrentVehicle(String driverUuid) async {
    loading = true;
    notifyListeners();

    currentVehicle = await _repo.getMyVehicle(driverUuid);

    loading = false;
    notifyListeners();
  }

  Future<VehicleEntity?> loadMyVehicle(String driverUuid) async {
    try {
      final vehicle = await _repo.remote.getMyVehicle(driverUuid);
      return vehicle;
    } catch (e) {
      print("⚠️ Error al cargar vehículo del conductor: $e");
      return null;
    }
  }

  // 🔹 Resetear selecciones
  void resetSelections() {
    selectedTypeId = null;
    selectedBrandId = null;
    selectedColorId = null;
    notifyListeners();
  }
}
