import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logEvent(String name, {Map<String, Object?>? params}) async {
    await _analytics.logEvent(name: name, parameters: params?.cast<String, Object>());
  }

  static Future<void> logAppOpened() async {
    await _analytics.logEvent(name: 'app_opened');
  }

  static Future<void> logBuscarMecanicos({int encontrados = 0}) async {
    await _analytics.logEvent(
      name: 'buscar_mecanicos',
      parameters: {'mecanicos_encontrados': encontrados},
    );
  }

  static Future<void> logSeleccionarMecanico(String nombre) async {
    await _analytics.logEvent(
      name: 'seleccionar_mecanico',
      parameters: {'nombre_mecanico': nombre},
    );
  }
}
