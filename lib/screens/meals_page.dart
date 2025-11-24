import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import '../widgets/meal_card.dart';

class MealsPage extends StatefulWidget {
  final String category;

  const MealsPage({super.key, required this.category});

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  final api = ApiService();
  List<Meal> meals = [];
  List<Meal> filteredMeals = [];

  @override
  void initState() {
    super.initState();
    loadMeals();
  }


  void loadMeals() async {
    meals = await api.loadMeals(widget.category);
    filteredMeals = meals;
    setState(() {});
  }

  void searchMeals(String query) async {
    if (query.isEmpty) {
      filteredMeals = meals;
    } else {
      final results = await api.searchMeals(query);
      filteredMeals = results;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),

      body: Column(
        children: [


          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [


                Expanded(
                  child: TextField(
                    onChanged: searchMeals,
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
                    final randomMeal = await api.randomMeal();
                    Navigator.pushNamed(
                      context,
                      "/detail",
                      arguments: randomMeal,
                    );
                  },
                ),
              ],
            ),
          ),


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
                return MealCard(meal: filteredMeals[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
