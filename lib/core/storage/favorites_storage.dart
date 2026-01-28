import 'package:shared_preferences/shared_preferences.dart';

/// Opslag service voor het beheren van favoriete auto's
class FavoritesStorage {
  static const String _favoritesKey = 'favorite_cars';

  /// Haal alle favoriete auto ID's op
  Future<Set<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoritesJson = prefs.getStringList(_favoritesKey);
    if (favoritesJson == null) return {};
    return favoritesJson.map((id) => int.parse(id)).toSet();
  }

  /// Voeg een auto toe aan favorieten
  Future<void> addFavorite(int carId) async {
    final favorites = await getFavorites();
    favorites.add(carId);
    await _saveFavorites(favorites);
  }

  /// Verwijder een auto uit favorieten
  Future<void> removeFavorite(int carId) async {
    final favorites = await getFavorites();
    favorites.remove(carId);
    await _saveFavorites(favorites);
  }

  /// Controleer of een auto gefavoriet is
  Future<bool> isFavorite(int carId) async {
    final favorites = await getFavorites();
    return favorites.contains(carId);
  }

  /// Schakel favoriet status om
  Future<bool> toggleFavorite(int carId) async {
    final isFav = await isFavorite(carId);
    if (isFav) {
      await removeFavorite(carId);
      return false;
    } else {
      await addFavorite(carId);
      return true;
    }
  }

  Future<void> _saveFavorites(Set<int> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favoritesJson =
        favorites.map((id) => id.toString()).toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }
}
