import 'package:flutter/material.dart';
import 'screens/category_page.dart';
import 'screens/details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const CategoriesPage(),
        '/detail': (_) => const DetailPage(),
      },
    );
  }
}
