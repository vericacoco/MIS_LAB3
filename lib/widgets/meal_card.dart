import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const MealCard({
    super.key,
    required this.meal,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // TAP ЗА DETAILS САМО НА СЛИКАТА
                Positioned.fill(
                  child: InkWell(
                    onTap: () async {
                      final detail =
                      await ApiService().loadMealDetail(meal.id);
                      Navigator.pushNamed(
                        context,
                        "/detail",
                        arguments: detail,
                      );
                    },
                    child: Image.network(
                      meal.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ❤️ FAVORITE КОПЧЕ (НЕ Е ЗАСЕНЕТО)
                Positioned(
                  top: 6,
                  right: 6,
                  child: IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: onToggleFavorite,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              meal.name,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
