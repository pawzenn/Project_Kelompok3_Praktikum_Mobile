import 'package:get/get.dart';

import '../login/signin_page.dart';
import '../login/signup_page.dart';
import '../modules/home/home_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  /// Route awal aplikasi (sekarang langsung ke halaman login)
  static const String initial = AppRoutes.login;

  static final List<GetPage> routes = <GetPage>[
    // Halaman Login
    GetPage(name: AppRoutes.login, page: () => const SignInPage()),

    // Halaman Register
    GetPage(name: AppRoutes.register, page: () => const SignUpPage()),

    // Main Menu / Home setelah login
    GetPage(name: AppRoutes.home, page: () => const HomeView()),
  ];
}
