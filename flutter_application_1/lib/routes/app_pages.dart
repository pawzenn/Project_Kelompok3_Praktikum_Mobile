import 'package:get/get.dart';
import '../modules/choice/choice_view.dart';
import '../modules/home/home_view.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: '/', page: () => const ChoiceView()),
    GetPage(name: '/home', page: () => const HomeView()),
  ];
}
