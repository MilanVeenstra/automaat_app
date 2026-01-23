import 'package:shared_preferences/shared_preferences.dart';

/// Storage service for managing favorite cars
class FavoritesStorage {
  static const String _favoritesKey = 'favorite_cars';

  /// Get all favorite car IDs
  Future<Set<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoritesJson = prefs.getStringList(_favoritesKey);
    if (favoritesJson == null) return {};
    return favoritesJson.map((id) => int.parse(id)).toSet();
  }

  /// Add a car to favorites
  Future<void> addFavorite(int carId) async {
    final favorites = await getFavorites();
    favorites.add(carId);
    await _saveFavorites(favorites);
  }

  /// Remove a car from favorites
  Future<void> removeFavorite(int carId) async {
    final favorites = await getFavorites();
    favorites.remove(carId);
    await _saveFavorites(favorites);
  }

  /// Check if a car is favorited
  Future<bool> isFavorite(int carId) async {
    final favorites = await getFavorites();
    return favorites.contains(carId);
  }

  /// Toggle favorite status
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
