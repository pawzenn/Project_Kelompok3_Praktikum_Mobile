import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/supabase/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'modules/cart/cart_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.instance.init();

  // controller global
  Get.put(ThemeController(), permanent: true);
  Get.put(CartController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          initialRoute: AppRoutes.login,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
