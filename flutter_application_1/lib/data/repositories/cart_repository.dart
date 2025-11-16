import '../../core/services/dio_client.dart';
import '../models/cart_item.dart';

enum ClientType { http, dio }

class RecipeRepository {
  static const String endpoint =
      'https://www.themealdb.com/api/json/v1/1/search.php?s=chicken';
}
