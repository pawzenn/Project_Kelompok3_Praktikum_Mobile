import 'package:get/get.dart';

// ===== AUTH / LOGIN =====
import '../login/signin_page.dart';
import '../login/signup_page.dart';

// ===== HOME, CART, PROFILE =====
import '../modules/home/home_view.dart';
import '../modules/home/home_controller.dart';
import '../modules/cart/cart_view.dart';
import '../modules/cart/cart_controller.dart';
import '../modules/profile/profile_view.dart';
import '../modules/profile/profile_controller.dart';

// ===== LOCATION MODULE (MODUL 5) =====
import '../modules/location/location_menu_view.dart';
import '../modules/location/location_live_view.dart';
import '../modules/location/location_network_view.dart';
import '../modules/location/views/location_gps_view.dart';

import '../modules/location/bindings/location_binding.dart';
import '../modules/location/bindings/network_location_binding.dart';
import '../modules/location/bindings/gps_location_binding.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    // ========== AUTH ==========
    GetPage(name: AppRoutes.login, page: () => const SignInPage()),
    GetPage(name: AppRoutes.register, page: () => const SignUpPage()),

    // ========== HOME ==========
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        // Home + CartController di-init di sini
        Get.put(HomeController());
        Get.put(CartController(), permanent: true);
      }),
    ),

    // ========== CART ==========
    GetPage(name: AppRoutes.cart, page: () => const CartView()),

    // ========== PROFILE ==========
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: BindingsBuilder(() {
        Get.put(ProfileController());
      }),
    ),

    // ========== LOCATION MENU (Logo lokasi di AppBar → ke sini) ==========
    GetPage(name: AppRoutes.locationMenu, page: () => const LocationMenuView()),

    // ========== LOCATION: LIVE (Eksperimen 3 – dinamis) ==========
    GetPage(
      name: AppRoutes.locationLive,
      page: () => const LocationLiveView(),
      binding:
          LocationBinding(), // di dalamnya Get.put(LocationLiveController())
    ),

    // ========== LOCATION: NETWORK (Eksperimen 1 & 2 – Network) ==========
    GetPage(
      name: AppRoutes.locationNetwork,
      page: () => const LocationNetworkView(),
      binding: NetworkLocationBinding(), // Get.put(LocationNetworkController())
    ),

    // ========== LOCATION: GPS (Eksperimen 1 & 2 – GPS) ==========
    GetPage(
      name: AppRoutes.locationGps,
      page: () => const LocationGpsView(),
      binding: GpsLocationBinding(), // Get.put(LocationGpsController())
    ),
  ];
}
