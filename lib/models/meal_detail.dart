class MealDetail {
  final String id;
  final String name;
  final String instructions;
  final String image;
  final String youtube;
  final List<String> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.instructions,
    required this.image,
    required this.youtube,
    required this.ingredients,
  });

  MealDetail.fromJson(Map<String, dynamic> data)
      : id = data['idMeal'],
        name = data['strMeal'],
        instructions = data['strInstructions'],
        image = data['strMealThumb'],
        youtube = data['strYoutube'] ?? "",
        ingredients = List.generate(20, (i) {
          final ing = data['strIngredient${i + 1}'];
          final measure = data['strMeasure${i + 1}'];
          if (ing != null && ing.toString().trim().isNotEmpty) {
            return "$ing - $measure";
          }
          return "";
        }).where((e) => e.isNotEmpty).toList();
}
