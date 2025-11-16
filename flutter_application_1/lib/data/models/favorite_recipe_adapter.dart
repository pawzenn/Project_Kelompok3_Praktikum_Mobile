import 'package:hive/hive.dart';
import 'favorite_recipe.dart';

class FavoriteRecipeAdapter extends TypeAdapter<FavoriteRecipe> {
  @override
  final int typeId = 1;

  @override
  FavoriteRecipe read(BinaryReader reader) {
    return FavoriteRecipe(
      id: reader.readString(),
      name: reader.readString(),
      thumbnail: reader.readString(),
      price: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteRecipe obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.thumbnail);
    writer.writeDouble(obj.price);
  }
}
