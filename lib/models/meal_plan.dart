class MealPlan {
  final List<Meals> meals;
  final List<Nutrients> nutrients;

  MealPlan({this.meals, this.nutrients});

  factory MealPlan.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['meals'] as List;
    List<Meals> mealList = list.map((i) => Meals.fromJson(i)).toList();
    var nutrientlist = parsedJson['meals'] as List;
    List<Nutrients> nutlList =
        nutrientlist.map((i) => Nutrients.fromJson(i)).toList();

    return MealPlan(meals: mealList, nutrients: nutlList);
  }
}

class Meals {
  final String id;
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
  final int calories;
  final int carbohydrates;
  final int fat;
  final int protein;

  Nutrients({this.calories, this.carbohydrates, this.fat, this.protein});
  factory Nutrients.fromJson(Map<String, dynamic> parsedJson) {
    return Nutrients(
        calories: parsedJson['calories'],
        carbohydrates: parsedJson['carbohydrates'],
        fat: parsedJson['fat'],
        protein: parsedJson['protein']);
  }
}
