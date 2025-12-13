import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../services/api_service.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'favorites_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final api = ApiService();

  List<Category> categories = [];
  List<Category> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await NotificationService.init();
    await NotificationService.showTestNotification();
  }

  Future<void> loadCategories() async {
    final data = await api.loadCategories();
    setState(() {
      categories = data;
      filteredCategories = data;
    });
  }

  void searchCategories(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        filteredCategories = categories;
      } else {
        filteredCategories = categories
            .where((c) =>
            c.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: searchCategories,
              decoration: InputDecoration(
                hintText: "Search categories...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // CATEGORY LIST
          Expanded(
            child: filteredCategories.isEmpty
                ? const Center(
              child: Text(
                "No categories found",
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (_, index) {
                return CategoryCard(
                  category: filteredCategories[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
