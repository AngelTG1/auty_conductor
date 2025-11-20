import 'package:auty_conductor/feature/request/presentation/provider/request_provider.dart';
import 'package:auty_conductor/core/ws/ws_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart'; // 👈 AÑADIDO

import 'firebase_options.dart';
import 'core/router/app_router.dart';

import 'feature/auth/presentation/providers/auth_provider.dart';
import 'feature/vehicle/presentation/providers/vehicle_provider.dart';
import 'feature/location/presentation/provider/location_provider.dart';
import 'feature/location/presentation/provider/tracking_provider.dart';

import 'core/services/analytics_service.dart';
import 'core/services/secure_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AnalyticsService.logAppOpened();

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
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => WsService()),
      ],
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final ws = Provider.of<WsService>(context, listen: false);
            final driverUuid = await SecureStorageService.read("driverUuid");
            final token = await SecureStorageService.read("token");

            if (driverUuid != null &&
                token != null &&
                token.isNotEmpty &&
                !ws.connected) {
              ws.connect(driverUuid);
            }
          });

          return ScreenUtilInit(
            designSize: const Size(390, 844), // 📱 Tamaño base (iPhone 12)
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return MaterialApp.router(
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
              );
            },
          );
        },
      ),
    );
  }
}
