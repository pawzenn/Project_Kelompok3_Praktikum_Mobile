import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/local/hive_service.dart';
import 'core/local/local_prefs_services.dart';
import 'core/supabase/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'modules/cart/cart_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'debug_storage_benchmark.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await SupabaseService.instance.init();
  await HiveService.init();

  final bool isLoggedIn = await LocalPrefsService.isLoggedIn();

  Get.put(ThemeController());
  Get.put(CartController());

  runApp(MyApp(initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login));

  if (kDebugMode) {
    runStorageBenchmark();
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
