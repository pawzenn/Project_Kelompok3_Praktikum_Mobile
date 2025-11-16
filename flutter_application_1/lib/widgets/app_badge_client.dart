import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/repositories/recipe_repository.dart';
import '../modules/choice/choice_controller.dart';

class AppBadgeClient extends StatelessWidget {
  const AppBadgeClient({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<ChoiceController>()
        ? Get.find<ChoiceController>()
        : null;
    return Obx(() {
      final t = c?.selected.value;
      final label = switch (t) {
        ClientType.http => 'HTTP',
        ClientType.dio => 'DIO',
        _ => '—',
      };
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF2F9362),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          'Aktif: $label',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    });
  }
}
