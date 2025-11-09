import 'package:auty_conductor/feature/location/presentation/pages/location_pages.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_type_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_brands_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_colors_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_summary_page.dart';
import 'package:auty_conductor/feature/home/presentation/pages/home_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/login_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/register_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/splash_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/select_role_page.dart';

import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    // Splash
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),

    // Login
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),

    // Registro
    GoRoute(path: AppRoutes.register, builder: (_, __) => const RegisterPage()),

    // Selección de rol
    GoRoute(
      path: '/select-role',
      builder: (context, state) {
        final userUuid = state.uri.queryParameters['uuid'] ?? '';
        return SelectRolePage(userUuid: userUuid);
      },
    ),

    // ✅ NUEVA ruta de aceptación de términos
    // GoRoute(path: '/terms', builder: (_, __) => const TermsAcceptancePage()),

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

    GoRoute(
      path: AppRoutes.locationMap,
      builder: (_, __) => const LocationPage(),
    ),
  ],
);

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const selectRole = '/select-role';
  static const terms = '/terms';
  static const vehicleType = '/vehicle/type';
  static const vehicleBrand = '/vehicle/brand';
  static const vehicleColor = '/vehicle/color';
  static const vehicleSummary = '/vehicle/summary';
  static const home = '/home';

    static const locationMap = '/location/map';
}
