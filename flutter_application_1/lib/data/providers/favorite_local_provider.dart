// lib/data/providers/favorite_local_provider.dart

import 'package:flutter_application_1/core/local/hive_service.dart';
import 'package:flutter_application_1/data/models/favorite_recipe.dart';
import 'package:hive/hive.dart';

class FavoriteLocalProvider {
  Box<FavoriteRecipe> get _box => HiveService.favoriteRecipesBox;

  /// Ambil semua favorite lokal
  List<FavoriteRecipe> getFavorites() {
    return _box.values.toList();
  }

  /// Cek apakah suatu recipe sudah jadi favorite
  bool isFavorite(String recipeId) {
    return _box.values.any((fav) => fav.id == recipeId);
  }

  /// Tambah favorite baru
  Future<void> addFavorite(FavoriteRecipe recipe) async {
    // kalau sudah ada, skip
    if (isFavorite(recipe.id)) return;
    await _box.add(recipe);
  }

  /// Hapus favorite berdasarkan id recipe
  Future<void> removeFavorite(String recipeId) async {
    final key = _box.keys.firstWhere(
      (k) => _box.get(k)?.id == recipeId,
      orElse: () => null,
    );

    if (key != null) {
      await _box.delete(key);
    }
  }

  /// Toggle favorite: kalau belum ada → tambah, kalau ada → hapus
  Future<void> toggleFavorite(FavoriteRecipe recipe) async {
    if (isFavorite(recipe.id)) {
      await removeFavorite(recipe.id);
    } else {
      await addFavorite(recipe);
    }
  }
}
