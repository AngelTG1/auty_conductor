class CommentEntity {
  final int id;
  final String driverUuid;
  final String driverName;
  final String driverPhoto;
  final String mechanicUuid;
  final String texto;
  final String sentimiento;
  final double puntuacion;
  final double toxicidad;

  CommentEntity({
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
}
