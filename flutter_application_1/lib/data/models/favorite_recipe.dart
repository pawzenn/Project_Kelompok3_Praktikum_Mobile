// lib/data/models/favorite_recipe.dart

import 'package:hive/hive.dart';

@HiveType(typeId: 1) // pastikan unique di project-mu
class FavoriteRecipe extends HiveObject {
  @HiveField(0)
  final String id; // id recipe (misal dari API / Supabase)

  @HiveField(1)
  final String name; // nama menu

  @HiveField(2)
  final String thumbnail; // URL gambar (bisa dari Supabase storage)

  @HiveField(3)
  final double price; // harga menu (optional tapi berguna)

  FavoriteRecipe({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.price,
  });
}
