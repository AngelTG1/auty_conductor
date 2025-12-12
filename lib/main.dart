import 'dart:async';
import 'package:auty_conductor/feature/request/presentation/provider/request_provider.dart';
import 'package:auty_conductor/core/ws/ws_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';
import 'core/router/app_router.dart';

import 'feature/auth/presentation/providers/auth_provider.dart';
import 'feature/vehicle/presentation/providers/vehicle_provider.dart';
import 'feature/location/presentation/provider/location_provider.dart';
import 'feature/location/presentation/provider/tracking_provider.dart';

import 'core/services/analytics_service.dart';
import 'core/services/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

// ⭐ Nuevos ⭐
import 'feature/chat/presentation/providers/chat_provider.dart';
import 'feature/chat/data/datasources/chat_remote_datasource.dart';
import 'feature/chat/data/repositories/chat_repository_impl.dart';
import 'feature/chat/domain/usecases/send_message_usecase.dart';
import 'feature/chat/domain/usecases/get_messages_usecase.dart';

import 'core/services/permission_service.dart';
import 'feature/comments/presentation/providers/comment_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PermissionService.requestLocationPermission();
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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => TrackingProvider()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => WsService()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),

        ChangeNotifierProvider(
          create: (context) {
            final ws = Provider.of<WsService>(context, listen: false);

            final dataSource = ChatRemoteDataSource();
            final repo = ChatRepositoryImpl(dataSource);

            return ChatProvider(
              sendUseCase: SendMessageUseCase(repo),
              getUseCase: GetMessagesUseCase(repo),
              ws: ws,
            );
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          // AUTO RECONEXION WS
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
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              final themeMode = context.watch<ThemeProvider>().themeMode;
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: appRouter,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
              );
            },
          );
        },
      ),
    );
  }
}
