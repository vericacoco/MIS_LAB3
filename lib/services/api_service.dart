import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const base = "https://www.themealdb.com/api/json/v1/1/";

  Future<List<Category>> loadCategories() async {
    final res = await http.get(Uri.parse("${base}categories.php"));
    final data = json.decode(res.body);
    return (data['categories'] as List)
        .map((c) => Category.fromJson(c))
        .toList();
  }

  Future<List<Meal>> loadMeals(String category) async {
    final res = await http.get(Uri.parse("${base}filter.php?c=$category"));
    final data = json.decode(res.body);
    return (data['meals'] as List)
        .map((m) => Meal.fromJson(m))
        .toList();
  }

  Future<List<Meal>> searchMeals(String query) async {
    final res = await http.get(Uri.parse("${base}search.php?s=$query"));
    final data = json.decode(res.body);

    if (data['meals'] == null) return [];

    return (data['meals'] as List)
        .map((m) => Meal.fromJson(m))
        .toList();
  }

  Future<MealDetail> loadMealDetail(String id) async {
    final res = await http.get(Uri.parse("${base}lookup.php?i=$id"));
    final data = json.decode(res.body)['meals'][0];
    return MealDetail.fromJson(data);
  }

  Future<MealDetail> randomMeal() async {
    final res = await http.get(Uri.parse("${base}random.php"));
    final data = json.decode(res.body)['meals'][0];
    return MealDetail.fromJson(data);
  }
}
