import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/favourites_service.dart';
import '../widgets/meal_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final favoritesService = FavoritesService();
  List<Meal> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await favoritesService.getFavorites();
    setState(() => favorites = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Recipes")),
      body: favorites.isEmpty
          ? const Center(
        child: Text(
          "No favorite recipes yet ❤️",
          style: TextStyle(fontSize: 16),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 200 / 250,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: favorites.length,
        itemBuilder: (_, index) {
          final meal = favorites[index];

          return MealCard(
            meal: meal,
            isFavorite: true,
            onToggleFavorite: () async {
              await favoritesService.removeFavorite(meal.id);
              loadFavorites(); // refresh
            },
          );
        },
      ),
    );
  }
}
