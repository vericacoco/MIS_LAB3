class Category {
  final String id;
  final String name;
  final String description;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  Category.fromJson(Map<String, dynamic> data)
      : id = data['idCategory'],
        name = data['strCategory'],
        description = data['strCategoryDescription'],
        image = data['strCategoryThumb'];
}
