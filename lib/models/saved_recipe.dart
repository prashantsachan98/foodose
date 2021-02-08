import 'package:hive/hive.dart';

part 'saved_recipe.g.dart';

@HiveType(typeId: 0)
class SavedRecipe {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;

  SavedRecipe({this.id, this.title});
}
