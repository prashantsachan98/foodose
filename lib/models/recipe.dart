class Recipe {
  final int id;
  final String title, imgURL, sourceUrl, instructions;

  Recipe({this.id, this.title, this.imgURL, this.sourceUrl, this.instructions});

  factory Recipe.fromMap(Map<dynamic, dynamic> map) {
    return Recipe(
        id: map['id'],
        title: map['title'],
        imgURL: map['image'],
        sourceUrl: map['sourceUrl'],
        instructions: map['instructions']);
  }
}
