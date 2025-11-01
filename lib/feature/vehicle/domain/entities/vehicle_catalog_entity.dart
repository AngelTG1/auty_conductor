class VehicleTypeEntity {
  final int id;
  final String name;
  final String imageUrl;
  VehicleTypeEntity(this.id, this.name, this.imageUrl);
}

class VehicleBrandEntity {
  final int id;
  final String name;
  VehicleBrandEntity(this.id, this.name);
}

class VehicleColorEntity {
  final int id;
  final String name;
  final String hexCode;
  VehicleColorEntity(this.id, this.name, this.hexCode);
}
