import '../../core/services/http_client.dart';
import '../../core/services/dio_client.dart';
import '../models/recipe.dart';

enum ClientType { http, dio }

class RecipeRepository {
  final HttpClientService httpClient;
  final DioClientService dioClient;
  static const String endpoint =
      'https://www.themealdb.com/api/json/v1/1/search.php?s=chicken';

  RecipeRepository({required this.httpClient, required this.dioClient});

  Future<List<Recipe>> fetchChickenRecipes(ClientType type) async {
    final Map<String, dynamic> data = switch (type) {
      ClientType.http => await httpClient.getJson(endpoint),
      ClientType.dio => await dioClient.getJson(endpoint),
    };
    final meals = data['meals'];
    if (meals == null) return <Recipe>[];
    final list = (meals as List)
        .whereType<Map<String, dynamic>>()
        .map((e) => Recipe.fromMealDb(e))
        .toList();
    return list;
  }
}
