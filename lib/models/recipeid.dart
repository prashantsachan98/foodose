class RecipeId {
  final int id;
  final String title, image, sourceUrl;
  final List<Ingredients> ingredients;
  final List<Instructions> instructions;

  RecipeId(
      {this.id,
      this.image,
      this.ingredients,
      this.sourceUrl,
      this.title,
      this.instructions});

  factory RecipeId.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['extendedIngredients'] as List;
    print(list.runtimeType); //returns List<dynamic>
    List<Ingredients> ingList =
        list.map((i) => Ingredients.fromJson(i)).toList();
    var insList = parsedJson['analyzedInstructions'] as List;
    print(list.runtimeType); //returns List<dynamic>
    List<Instructions> instList =
        insList.map((i) => Instructions.fromJson(i)).toList();

    return RecipeId(
        id: parsedJson['id'],
        title: parsedJson['title'],
        image: parsedJson['image'],
        sourceUrl: parsedJson['sourceUrl'],
        ingredients: ingList,
        instructions: instList);
  }
}

class Ingredients {
  final String name;

  Ingredients({this.name});
  factory Ingredients.fromJson(Map<String, dynamic> parsedJson) {
    return Ingredients(name: parsedJson['name']);
  }
}

class Instructions {
  final List<Steps> steps;
  Instructions({this.steps});
  factory Instructions.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['steps'] as List;
    print(list.runtimeType); //returns List<dynamic>
    List<Steps> insList = list.map((i) => Steps.fromJson(i)).toList();

    return Instructions(steps: insList);
  }
}

class Steps {
  final String step;

  Steps({this.step});
  factory Steps.fromJson(Map<String, dynamic> parsedJson) {
    return Steps(
      step: parsedJson['step'],
    );
  }
}
