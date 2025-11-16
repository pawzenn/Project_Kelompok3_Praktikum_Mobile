import 'package:get/get.dart';
import '../../data/repositories/recipe_repository.dart';

class ChoiceController extends GetxController {
  final selected = Rx<ClientType?>(null);

  void choose(ClientType type) {
    selected.value = type;
  }
}
