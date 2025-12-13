import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/api_service.dart';
import '../services/favourites_service.dart';
import '../widgets/meal_card.dart';

class MealsPage extends StatefulWidget {
  final String category;

  const MealsPage({super.key, required this.category});

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  final api = ApiService();
  final favoritesService = FavoritesService();

  List<Meal> meals = [];
  List<Meal> filteredMeals = [];

  // локален UI state за срцата (Firestore е извор на вистина, ова е за UX)
  final Set<String> favoriteMealIds = {};

  @override
  void initState() {
    super.initState();
    loadMeals();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favs = await favoritesService.getFavorites();

    setState(() {
      favoriteMealIds.clear();
      for (final meal in favs) {
        favoriteMealIds.add(meal.id);
      }
    });
  }


  Future<void> loadMeals() async {
    final loaded = await api.loadMeals(widget.category);
    setState(() {
      meals = loaded;
      filteredMeals = loaded;
    });
  }

  Future<void> searchMeals(String query) async {
    if (query.trim().isEmpty) {
      setState(() => filteredMeals = meals);
      return;
    }

    final results = await api.searchMeals(query.trim());
    setState(() => filteredMeals = results);
  }

  Future<void> toggleFavorite(Meal meal) async {
    final wasFav = favoriteMealIds.contains(meal.id);

    // 1) UI toggle веднаш (побрз UX)
    setState(() {
      if (wasFav) {
        favoriteMealIds.remove(meal.id);
      } else {
        favoriteMealIds.add(meal.id);
      }
    });

    // 2) Firestore sync
    if (wasFav) {
      await favoritesService.removeFavorite(meal.id);
    } else {
      await favoritesService.addFavorite(meal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: Column(
        children: [
          // SEARCH + SHUFFLE
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => searchMeals(v),
                    decoration: InputDecoration(
                      hintText: "Search meals...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.shuffle, size: 30),
                  onPressed: () async {
                    final randomMealDetail = await api.randomMeal();
                    if (!mounted) return;
                    Navigator.pushNamed(
                      context,
                      "/detail",
                      arguments: randomMealDetail,
                    );
                  },
                ),
              ],
            ),
          ),

          // GRID
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 200 / 250,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: filteredMeals.length,
              itemBuilder: (_, index) {
                final meal = filteredMeals[index];

                return MealCard(
                  meal: meal,
                  isFavorite: favoriteMealIds.contains(meal.id),
                  onToggleFavorite: () => toggleFavorite(meal),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
