import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_type_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_brands_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_colors_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_summary_page.dart';
import 'package:auty_conductor/feature/home/presentation/pages/home_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/login_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/register_page.dart'; // ✅ Nuevo import
import 'package:auty_conductor/feature/auth/presentation/pages/splash_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/select_role_page.dart'; // ✅ Ruta para rol

import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    // Splash
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),

    // Login
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),

    // ✅ Nueva ruta para registro
    GoRoute(path: AppRoutes.register, builder: (_, __) => const RegisterPage()),

    // ✅ Ruta nueva para seleccionar rol
    GoRoute(
      path: '/select-role',
      builder: (context, state) {
        final userUuid = state.extra as String;
        return SelectRolePage(userUuid: userUuid);
      },
    ),

    // Vehículos
    GoRoute(
      path: AppRoutes.vehicleType,
      builder: (_, __) => const VehicleTypePage(),
    ),
    GoRoute(
      path: AppRoutes.vehicleBrand,
      builder: (_, __) => const VehicleBrandsPage(),
    ),
    GoRoute(
      path: AppRoutes.vehicleColor,
      builder: (_, __) => const VehicleColorsPage(),
    ),
    GoRoute(
      path: AppRoutes.vehicleSummary,
      builder: (_, __) => const VehicleSummaryPage(),
    ),

    // Home
    GoRoute(path: AppRoutes.home, builder: (_, __) => const HomePage()),
  ],
);

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register'; // ✅ Nueva constante para registro
  static const vehicleType = '/vehicle/type';
  static const vehicleBrand = '/vehicle/brand';
  static const vehicleColor = '/vehicle/color';
  static const vehicleSummary = '/vehicle/summary';
  static const home = '/home';
}
