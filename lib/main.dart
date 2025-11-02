import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'feature/auth/presentation/providers/auth_provider.dart';
import 'feature/vehicle/presentation/providers/vehicle_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fuerza la inicialización del secure storage antes de runApp
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
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.grey[100],
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
      ),
    );
  }
}
