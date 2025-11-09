import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// 🔹 Evento genérico
  static Future<void> logEvent(String name, {Map<String, Object?>? params}) async {
    await _analytics.logEvent(name: name, parameters: params?.cast<String, Object>());
  }

  /// 🔹 Cuando se abre la app
  static Future<void> logAppOpened() async {
    await _analytics.logEvent(name: 'app_opened');
  }

  /// 🔹 Cuando se buscan mecánicos
  static Future<void> logBuscarMecanicos({int encontrados = 0}) async {
    await _analytics.logEvent(
      name: 'buscar_mecanicos',
      parameters: {'mecanicos_encontrados': encontrados},
    );
  }

  /// 🔹 Cuando se selecciona un mecánico
  static Future<void> logSeleccionarMecanico(String nombre) async {
    await _analytics.logEvent(
      name: 'seleccionar_mecanico',
      parameters: {'nombre_mecanico': nombre},
    );
  }
}
