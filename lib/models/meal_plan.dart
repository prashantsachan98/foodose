class MealPlan {
  final List<Meals> meals;
  final Nutrients nutrients;

  MealPlan({this.meals, this.nutrients});

  factory MealPlan.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['meals'] as List;
    List<Meals> mealList = list.map((i) => Meals.fromJson(i)).toList();

    return MealPlan(
        meals: mealList,
        nutrients: Nutrients.fromJson(parsedJson['nutrients']));
  }
}

class Meals {
  final int id;
  final String title;
  final String sourceUrl;

  Meals({this.id, this.title, this.sourceUrl});
  factory Meals.fromJson(Map<String, dynamic> parsedJson) {
    return Meals(
      id: parsedJson['id'],
      title: parsedJson['title'],
      sourceUrl: parsedJson['sourceUrl'],
    );
  }
}

class Nutrients {
  final double calories;
  final double carbohydrates;
  final double fat;
  final double protein;

  Nutrients({this.calories, this.carbohydrates, this.fat, this.protein});
  factory Nutrients.fromJson(Map<String, dynamic> parsedJson) {
    return Nutrients(
        calories: parsedJson['calories'],
        carbohydrates: parsedJson['carbohydrates'],
        fat: parsedJson['fat'],
        protein: parsedJson['protein']);
  }
}
