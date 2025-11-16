import 'dart:math'; // untuk hitung std dev
import 'package:get/get.dart';

import '../../data/models/cart_item.dart';
import '../../data/repositories/cart_repository.dart';
import '../../core/services/dio_client.dart';

class HomeController extends GetxController {
  final RecipeRepository repo = Get.find<RecipeRepository>();
  final ChoiceController choice = Get.find<ChoiceController>();

  // UI state
  final isLoading = false.obs;
  final error = RxnString(null);
  final recipes = <Recipe>[].obs;

  // Ringkasan hasil benchmark ditaruh di sini supaya bisa di-observe dari UI
  final httpSummary = Rxn<Map<String, num>>();
  final dioSummary = Rxn<Map<String, num>>();

  @override
  void onInit() {
    super.onInit();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    final t = choice.selected.value;
    if (t == null) return;
    isLoading.value = true;
    error.value = null;
    try {
      final data = await repo.fetchChickenRecipes(t);
      recipes.assignAll(data);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ----------------- BENCHMARK UTIL -----------------

  Future<int> _measureHttpOnce() async {
    final url =
        'https://www.themealdb.com/api/json/v1/1/search.php?s=chicken&_ts=${DateTime.now().millisecondsSinceEpoch}';
    final sw = Stopwatch()..start();
    await Get.find<HttpClientService>().getJson(url);
    sw.stop();
    return sw.elapsedMilliseconds;
  }

  Future<int> _measureDioOnce() async {
    final url =
        'https://www.themealdb.com/api/json/v1/1/search.php?s=chicken&_ts=${DateTime.now().millisecondsSinceEpoch}';
    final sw = Stopwatch()..start();
    await Get.find<DioClientService>().getJson(url);
    sw.stop();
    return sw.elapsedMilliseconds;
  }

  Future<Map<String, num>> _runBenchmark(
    int n,
    Future<int> Function() runOnce,
  ) async {
    final times = <int>[];
    for (var i = 0; i < n; i++) {
      final ms = await runOnce();
      times.add(ms);
      await Future.delayed(const Duration(milliseconds: 250)); // jeda kecil
    }
    times.sort();
    final avg = times.reduce((a, b) => a + b) / times.length;
    final minV = times.first;
    final maxV = times.last;
    final p95 = times[(times.length * 0.95).ceil() - 1];
    final mean = avg;
    final variance =
        times.map((t) => (t - mean) * (t - mean)).reduce((a, b) => a + b) /
        times.length;
    final stddev = sqrt(variance);
    return {
      'n': times.length,
      'avg': avg,
      'p95': p95,
      'min': minV,
      'max': maxV,
      'std': stddev,
    };
  }

  // Dipanggil dari tombol di AppBar Home
  Future<void> runHttpBenchmark({int n = 10}) async {
    httpSummary.value = await _runBenchmark(n, _measureHttpOnce);
  }

  Future<void> runDioBenchmark({int n = 10}) async {
    dioSummary.value = await _runBenchmark(n, _measureDioOnce);
  }
}
