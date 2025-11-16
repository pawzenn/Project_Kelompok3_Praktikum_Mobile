import 'package:get/get.dart';

import '../login/signin_page.dart';
import '../login/signup_page.dart';
import '../modules/home/home_view.dart';
import '../modules/home/home_controller.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(name: AppRoutes.login, page: () => const SignInPage()),
    GetPage(name: AppRoutes.register, page: () => const SignUpPage()),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
    ),
  ];
}
