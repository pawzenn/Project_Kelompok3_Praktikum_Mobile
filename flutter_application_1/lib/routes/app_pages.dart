import 'package:get/get.dart';

import '../modules/home/home_view.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: '/home', page: () => const HomeView()),
  ];
}
