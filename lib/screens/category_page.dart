import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final api = ApiService();
  List<Category> categories = [];
  List<Category> filtered = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    categories = await api.loadCategories();
    filtered = categories;
    setState(() {});
  }

  void search(String text) {
    setState(() {
      filtered = categories
          .where((c) => c.name.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () async {
              final meal = await api.randomMeal();
              Navigator.pushNamed(context, "/detail", arguments: meal);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: search,
              decoration: const InputDecoration(
                hintText: "Search categories...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) =>
                  CategoryCard(category: filtered[index]),
            ),
          ),
        ],
      ),
    );
  }
}
