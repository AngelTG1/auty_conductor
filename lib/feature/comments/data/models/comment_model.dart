class CommentModel {
  final int id;
  final String driverUuid;
  final String driverName;
  final String driverPhoto;
  final String mechanicUuid;
  final String texto;
  final String sentimiento;
  final double puntuacion;
  final double toxicidad;

  CommentModel({
    required this.id,
    required this.driverUuid,
    required this.driverName,
    required this.driverPhoto,
    required this.mechanicUuid,
    required this.texto,
    required this.sentimiento,
    required this.puntuacion,
    required this.toxicidad,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json["id"],
      driverUuid: json["driver_uuid"],
      driverName: json["driver_name"] ?? "Usuario",
      driverPhoto: json["driver_photo"] ?? "",
      mechanicUuid: json["mechanic_uuid"],
      texto: json["texto"],
      sentimiento: json["sentimiento"],
      puntuacion: (json["puntuacion"] ?? 0).toDouble(),
      toxicidad: (json["toxicidad"] ?? 0).toDouble(),
    );
  }
}
