import 'package:get/get.dart';

import '../login/signin_page.dart';
import '../login/signup_page.dart';
import '../modules/home/home_view.dart';
import '../modules/home/home_controller.dart';
import '../modules/cart/cart_view.dart';
import '../modules/cart/cart_controller.dart';
import '../modules/profile/profile_view.dart';
import '../modules/profile/profile_controller.dart';
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
        Get.put(CartController(), permanent: true); // ✅ cukup di sini
      }),
    ),

    GetPage(name: AppRoutes.cart, page: () => const CartView()),

    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: BindingsBuilder(() {
        Get.put(ProfileController());
      }),
    ),
  ];
}
