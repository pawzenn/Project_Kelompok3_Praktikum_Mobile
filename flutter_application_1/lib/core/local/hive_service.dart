// lib/core/local/hive_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/favorite_recipe.dart';
import '../../data/models/favorite_recipe_adapter.dart';

class HiveBoxes {
  static const String favoriteRecipes = 'favorite_recipes';
}

class HiveService {
  /// Panggil sekali di main() sebelum runApp()
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapter manual
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FavoriteRecipeAdapter());
    }

    // Buka box yang diperlukan
    await Hive.openBox<FavoriteRecipe>(HiveBoxes.favoriteRecipes);
  }

  /// Akses box favorite recipes
  static Box<FavoriteRecipe> get favoriteRecipesBox =>
      Hive.box<FavoriteRecipe>(HiveBoxes.favoriteRecipes);
}
