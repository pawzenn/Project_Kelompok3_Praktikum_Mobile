import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/notifications/local_notification_service.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/local/hive_service.dart';
import 'core/local/local_prefs_services.dart';
import 'core/supabase/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'modules/cart/cart_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'debug_storage_benchmark.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/notifications/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(FcmService.backgroundHandler);

  await LocalNotificationService.init();
  await FcmService().init();

  await dotenv.load(fileName: '.env');

  await SupabaseService.instance.init();
  await HiveService.init();

  debugPrint('✅ Firebase initialized: ${Firebase.app().options.projectId}');

  final bool isLoggedIn = await LocalPrefsService.isLoggedIn();

  Get.put(ThemeController());
  Get.put(CartController());

  runApp(MyApp(initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login));

  if (kDebugMode) {
    Future.microtask(runStorageBenchmark);
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, this.initialRoute = AppRoutes.home});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Lalapan Bang Ajey',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          initialRoute: initialRoute,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
