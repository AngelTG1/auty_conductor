import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_type_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_brands_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_colors_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_summary_page.dart';
import 'package:auty_conductor/feature/home/presentation/pages/home_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/login_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/splash_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
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
    GoRoute(path: AppRoutes.home, builder: (_, __) => const HomePage()),
  ],
);

class AppRoutes {
  static const splash = '/'; 
  static const login = '/login';
  static const vehicleType = '/vehicle/type';
  static const vehicleBrand = '/vehicle/brand';
  static const vehicleColor = '/vehicle/color';
  static const vehicleSummary = '/vehicle/summary';
  static const home = '/home';
}
