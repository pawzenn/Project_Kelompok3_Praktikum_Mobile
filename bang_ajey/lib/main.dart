import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/recipe_repository.dart';
import 'core/services/http_client.dart';
import 'core/services/dio_client.dart';

void main() {
  // Singletons ringan
  Get.put(HttpClientService(), permanent: true);
  Get.put(DioClientService(), permanent: true);
  Get.put(
      RecipeRepository(
        httpClient: Get.find<HttpClientService>(),
        dioClient: Get.find<DioClientService>(),
      ),
      permanent: true);

  runApp(const BangAjeyMealsApp());
}

class BangAjeyMealsApp extends StatelessWidget {
  const BangAjeyMealsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lalapan Bang Ajey',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: AppRoutes.choice,
      getPages: AppPages.pages,
    );
  }
}
