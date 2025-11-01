import 'package:flutter/material.dart';
import 'package:auty_conductor/feature/vehicle/data/datasources/vehicle_remote_datasource.dart';
import 'package:auty_conductor/feature/vehicle/data/repositories/vehicle_repository_impl.dart';
import 'package:auty_conductor/feature/vehicle/domain/entities/vehicle_catalog_entity.dart';
import 'package:auty_conductor/feature/vehicle/domain/usecases/register_vehicle_usecase.dart';

class VehicleProvider extends ChangeNotifier {
  // 🔹 Repositorio que conecta con el datasource remoto
  final _repo = VehicleRepositoryImpl(VehicleRemoteDataSource());

  // 🔹 Listas de catálogos (tipo, marca, color)
  List<VehicleTypeEntity> types = [];
  List<VehicleBrandEntity> brands = [];
  List<VehicleColorEntity> colors = [];

  // 🔹 Variables seleccionadas por el usuario
  int? selectedTypeId;
  int? selectedBrandId;
  int? selectedColorId;

  bool loading = false;

  // 🔹 Carga inicial de catálogos
  Future<void> loadCatalogs() async {
    loading = true;
    notifyListeners();

    types = await _repo.getTypes();
    brands = await _repo.getBrands();
    colors = await _repo.getColors();

    loading = false;
    notifyListeners();
  }

  // 🔹 Métodos para selección individual
  void selectType(int id) {
    selectedTypeId = id;
    notifyListeners();
  }

  void selectBrand(int id) {
    selectedBrandId = id;
    notifyListeners();
  }

  void selectColor(int id) {
    selectedColorId = id;
    notifyListeners();
  }

  // 🔹 Registrar vehículo (usa el caso de uso)
  Future<void> registerVehicle(String driverUuid) async {
    if (selectedTypeId == null || selectedBrandId == null || selectedColorId == null) {
      throw Exception("Debes seleccionar tipo, marca y color");
    }

    final usecase = RegisterVehicleUseCase(_repo);
    await usecase.call(driverUuid, selectedTypeId!, selectedBrandId!, selectedColorId!);
  }

  // 🔹 Nuevo método: limpiar todas las selecciones
  void resetSelections() {
    selectedTypeId = null;
    selectedBrandId = null;
    selectedColorId = null;
    notifyListeners();
  }
}
