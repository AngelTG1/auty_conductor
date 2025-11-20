import 'package:auty_conductor/feature/location/presentation/pages/driver_tracking_mechanic_page.dart';
import 'package:auty_conductor/feature/location/presentation/pages/mechanic_info_page.dart';
import 'package:auty_conductor/feature/profile/presentation/pages/privacy_webview_page.dart';
import 'package:go_router/go_router.dart';

// 🔹 Pages principales
import 'package:auty_conductor/feature/layout/main_layout.dart';
import 'package:auty_conductor/feature/location/presentation/pages/location_pages.dart';

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

// 🔹 Mecánico Express
import 'package:auty_conductor/feature/request/presentation/pages/express_mechanic_page.dart';

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

    // 🏠 Home
    GoRoute(path: AppRoutes.home, builder: (_, __) => const MainLayout()),

    // 📍 Mapa
    GoRoute(
      path: AppRoutes.locationMap,
      builder: (_, __) => const LocationPage(),
    ),

    // ⚡ Mecánico Express
    GoRoute(
      path: AppRoutes.expressMechanic,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?; // <-- Recibe MAP
        final mechanicUuid = args?["mechanicUuid"] as String?;
        return ExpressMechanicPage(mechanicUuid: mechanicUuid);
      },
    ),

    // 🌐 Aviso de privacidad
    GoRoute(
      path: AppRoutes.privacyWeb,
      builder: (_, __) => const PrivacyWebViewPage(),
    ),

    // ℹ Información del mecánico
    GoRoute(
      path: "/mechanic-info",
      builder: (context, state) {
        final mechanicUuid = state.extra as String; // <-- Recibe SOLO STRING
        return MechanicInfoPage(mechanicUuid: mechanicUuid);
      },
    ),

    // 🚗 Seguimiento en vivo del mecánico (driver)
    GoRoute(
      path: AppRoutes.driverTrackingMechanic,
      builder: (context, state) {
        final request = state.extra as Map<String, dynamic>;
        return DriverTrackingMechanicPage(request: request);
      },
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
  static const driverTrackingMechanic = '/tracking/mechanic';

  // ⚡ Mecánico express
  static const expressMechanic = '/express-mechanic';

  // 📍 Mapa
  static const locationMap = '/location/map';

  static const privacyWeb = '/privacy-web';
}
