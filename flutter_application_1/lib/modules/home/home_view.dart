import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/app_badge_client.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_skeleton.dart';
import 'home_controller.dart';
import 'widgets/product_card.dart';
import 'widgets/product_quantity_control.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lalapan Bang Ajey'),
        centerTitle: true,
        actions: [
          // 🔵 Tombol uji 10x HTTP
          IconButton(
            tooltip: 'Uji 10x HTTP',
            icon: const Icon(Icons.speed),
            onPressed: () async {
              await c.runHttpBenchmark(n: 10);
              final s = c.httpSummary.value!;
              Get.snackbar(
                'HTTP (10x)',
                'avg: ${s['avg']!.toStringAsFixed(0)} ms • p95: ${s['p95']} • '
                    'min: ${s['min']} • max: ${s['max']} • std: ${s['std']!.toStringAsFixed(1)}',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          // 🟢 Tombol uji 10x Dio
          IconButton(
            tooltip: 'Uji 10x Dio',
            icon: const Icon(Icons.stacked_line_chart),
            onPressed: () async {
              await c.runDioBenchmark(n: 10);
              final s = c.dioSummary.value!;
              Get.snackbar(
                'Dio (10x)',
                'avg: ${s['avg']!.toStringAsFixed(0)} ms • p95: ${s['p95']} • '
                    'min: ${s['min']} • max: ${s['max']} • std: ${s['std']!.toStringAsFixed(1)}',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: AppBadgeClient(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Panel ringkasan hasil uji
          Obx(() {
            final h = c.httpSummary.value;
            final d = c.dioSummary.value;
            if (h == null && d == null) return const SizedBox.shrink();

            String fmt(Map<String, num> s) =>
                'avg ${s['avg']!.toStringAsFixed(0)}ms • p95 ${s['p95']} • '
                'min ${s['min']} • max ${s['max']} • std ${s['std']!.toStringAsFixed(1)}';

            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (h != null) Text('HTTP : ${fmt(h)}'),
                      if (d != null) Text('DIO  : ${fmt(d)}'),
                    ],
                  ),
                ),
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) return const LoadingSkeletonGrid();
              if (c.error.value != null) {
                return ErrorState(
                  message: 'Gagal memuat data.\n${c.error.value}',
                  onRetry: () => c.loadRecipes(),
                );
              }
              if (c.recipes.isEmpty) {
                return const EmptyState(message: 'Tidak ada menu ditemukan.');
              }

              return RefreshIndicator(
                onRefresh: c.loadRecipes,
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: c.recipes.length,
                  itemBuilder: (context, i) {
                    final r = c.recipes[i];
                    return RecipeCard(
                      recipe: r,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => RecipeDetailSheet(recipe: r),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
