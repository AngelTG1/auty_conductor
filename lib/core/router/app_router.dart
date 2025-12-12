import 'package:auty_conductor/feature/chat/presentation/pages/chat_page.dart';
import 'package:auty_conductor/feature/location/presentation/pages/driver_tracking_mechanic_page.dart';
import 'package:auty_conductor/feature/location/presentation/pages/mechanic_info_page.dart';
import 'package:auty_conductor/feature/profile/presentation/pages/privacy_webview_page.dart';
import 'package:auty_conductor/feature/request/presentation/pages/mechanic_tracking_page.dart';
import 'package:go_router/go_router.dart';

import 'package:auty_conductor/feature/layout/main_layout.dart';
import 'package:auty_conductor/feature/location/presentation/pages/location_pages.dart';

import 'package:auty_conductor/feature/auth/presentation/pages/splash_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/login_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/register_page.dart';
import 'package:auty_conductor/feature/auth/presentation/pages/select_role_page.dart';

import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_type_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_brands_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_colors_page.dart';
import 'package:auty_conductor/feature/vehicle/presentation/pages/vehicle_summary_page.dart';

import 'package:auty_conductor/feature/request/presentation/pages/express_mechanic_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),

    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),

    GoRoute(path: AppRoutes.register, builder: (_, __) => const RegisterPage()),

    GoRoute(
      path: AppRoutes.selectRole,
      builder: (context, state) {
        final userUuid = state.uri.queryParameters['uuid'] ?? '';
        return SelectRolePage(userUuid: userUuid);
      },
    ),

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

    GoRoute(path: AppRoutes.home, builder: (_, __) => const MainLayout()),

    GoRoute(
      path: AppRoutes.locationMap,
      builder: (_, __) => const LocationPage(),
    ),

    // ⚡ Mecánico Express
    GoRoute(
      path: AppRoutes.expressMechanic,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?; 
        final mechanicUuid = args?["mechanicUuid"] as String?;
        return ExpressMechanicPage(mechanicUuid: mechanicUuid);
      },
    ),

    GoRoute(
      path: AppRoutes.privacyWeb,
      builder: (_, __) => const PrivacyWebViewPage(),
    ),

    GoRoute(
      path: "/mechanic-info",
      builder: (context, state) {
        final mechanicUuid = state.extra as String; 
        return MechanicInfoPage(mechanicUuid: mechanicUuid);
      },
    ),

    GoRoute(
      path: AppRoutes.driverTrackingMechanic,
      builder: (context, state) {
        final request = state.extra as Map<String, dynamic>;
        return DriverTrackingMechanicPage(request: request);
      },
    ),

    GoRoute(
      path: "/tracking",
      name: AppRoutes.tracking,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return MechanicTrackingPage(request: data);
      },
    ),

    GoRoute(
      path: "/chat",
      name: "chatPage",
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return ChatPage(
          chatUuid: data["chatUuid"],
          driverUuid: data["driverUuid"],
          mechanicUuid: data["mechanicUuid"],
        );
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

  static const vehicleType = '/vehicle/type';
  static const vehicleBrand = '/vehicle/brand';
  static const vehicleColor = '/vehicle/color';
  static const vehicleSummary = '/vehicle/summary';

  static const home = '/home';
  static const driverTrackingMechanic = '/tracking/mechanic';

  static const expressMechanic = '/express-mechanic';

  static const locationMap = '/location/map';

  static const privacyWeb = '/privacy-web';
  static const tracking = "/tracking";

  static const chat = "/chat";
}
