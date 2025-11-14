import 'package:auty_conductor/feature/profile/presentation/pages/privacy_webview_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

// 🔹 Pages principales
import 'package:auty_conductor/feature/layout/main_layout.dart';
import 'package:auty_conductor/feature/location/presentation/pages/location_pages.dart';
import 'package:auty_conductor/feature/home/presentation/pages/home_page.dart';
import 'package:auty_conductor/feature/profile/presentation/pages/profile_page.dart';

// 🔹 Pages de autenticación
import 'package:auty_conductor/feature/auth/presentation/pages/splash_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/login_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/register_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/select_role_page.dart';

// 🔹 Pages de vehículo
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_type_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_brands_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_colors_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_summary_page.dart';

import 'package:auty_conductor/feature/request/presentation/pages/express_mechanic_page.dart';

import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    // 🟦 Splash
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),

    // 🔐 Login
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),

    // 📝 Registro
    GoRoute(path: AppRoutes.register, builder: (_, __) => const RegisterPage()),

    // 👤 Selección de rol
    GoRoute(
      path: AppRoutes.selectRole,
      builder: (context, state) {
        final userUuid = state.uri.queryParameters['uuid'] ?? '';
        return SelectRolePage(userUuid: userUuid);
      },
    ),

    // 🚗 Registro de vehículo
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

    // 🏠 Home dentro del MainLayout (con navegación inferior)
    GoRoute(path: AppRoutes.home, builder: (_, __) => const MainLayout()),

    // 📍 Mapa de mecánicos
    GoRoute(
      path: AppRoutes.locationMap,
      builder: (_, __) => const LocationPage(),
    ),

    GoRoute(
      path: AppRoutes.expressMechanic,
      builder: (_, __) => const ExpressMechanicPage(),
    ),
    GoRoute(
  path: AppRoutes.privacyWeb,
  builder: (context, state) => const PrivacyWebViewPage(),
),

  ],
);

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const selectRole = '/select-role';
  static const terms = '/terms';

  // 🚗 Vehículos
  static const vehicleType = '/vehicle/type';
  static const vehicleBrand = '/vehicle/brand';
  static const vehicleColor = '/vehicle/color';
  static const vehicleSummary = '/vehicle/summary';

  // 🏠 Principal
  static const home = '/home';
  static const expressMechanic = '/mechanic/express';
  // 📍 Mapa
  static const locationMap = '/location/map';

  static const privacyWeb = '/privacy-web';

}
