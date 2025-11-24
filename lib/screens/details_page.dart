import 'package:flutter/material.dart';
import '../models/meal_detail.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final meal = ModalRoute.of(context)!.settings.arguments as MealDetail;

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(meal.image),
            ),

            const SizedBox(height: 25),


            const Text(
              "Ingredients",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),


            ...meal.ingredients.map(
                  (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "• $e",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 25),


            const Text(
              "Instructions",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),


            Text(
              meal.instructions,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 25),


            if (meal.youtube.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "YouTube",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(

                    child: Text(
                      meal.youtube,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
