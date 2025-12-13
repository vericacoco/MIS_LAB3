import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal.dart';

class FavoritesService {
  final _db = FirebaseFirestore.instance;
  final _collection = 'favorites';

  Future<void> addFavorite(Meal meal) async {
    await _db.collection(_collection).doc(meal.id).set({
      'id': meal.id,
      'name': meal.name,
      'image': meal.image,
    });
  }

  Future<void> removeFavorite(String mealId) async {
    await _db.collection(_collection).doc(mealId).delete();
  }

  /// THIS WAS MISSING
  Future<List<Meal>> getFavorites() async {
    final snapshot = await _db.collection(_collection).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Meal(
        id: data['id'],
        name: data['name'],
        image: data['image'],
      );
    }).toList();
  }
}


