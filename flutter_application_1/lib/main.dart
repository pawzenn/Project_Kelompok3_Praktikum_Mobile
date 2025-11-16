import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/supabase/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase dari service singleton
  await SupabaseService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lalapan Bang Ajey',
      theme: AppTheme.lightTheme, // ⬅️ pakai getter dari AppTheme
      initialRoute: AppRoutes.login,
      getPages: AppPages.routes,
    );
  }
}
