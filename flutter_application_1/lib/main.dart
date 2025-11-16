import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/supabase/supabase_service.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase (sekaligus load .env)
  await SupabaseService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Mulai dari halaman login (didefinisikan di AppPages)
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
