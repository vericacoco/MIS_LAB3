class Meal {
  final String id;
  final String name;
  final String image;

  Meal({
    required this.id,
    required this.name,
    required this.image,
  });

  Meal.fromJson(Map<String, dynamic> data)
      : id = data['idMeal'],
        name = data['strMeal'],
        image = data['strMealThumb'];
}
