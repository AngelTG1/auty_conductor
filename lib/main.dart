import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// 🔹 Configuración de Firebase
import 'firebase_options.dart';

// 🔹 Rutas y Providers existentes
import 'core/router/app_router.dart';
import 'feature/auth/presentation/providers/auth_provider.dart';
import 'feature/vehicle/presentation/providers/vehicle_provider.dart';

// 🔹 Providers de ubicación
import 'feature/location/presentation/provider/location_provider.dart';
import 'feature/location/presentation/provider/tracking_provider.dart';

// 🔹 Nuevo servicio de Analytics
import 'core/services/analytics_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Registrar evento al abrir la app
  await AnalyticsService.logAppOpened();

  // ✅ Inicializar almacenamiento seguro
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  await secureStorage.read(key: 'token');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => TrackingProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.grey[100],
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E329D),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
      ),
    );
  }
}
