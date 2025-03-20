import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/movie.dart';


class LocalDataSource {
  final SharedPreferences prefs;

  LocalDataSource({required this.prefs});

  Future<void> saveFavoriteMovies(List<Movie> newFavorites) async {
    // Get the existing favorites
    final existingFavorites = getFavoriteMovies();

    // Combine existing favorites with new favorites
    final updatedFavorites = [...existingFavorites, ...newFavorites];

    // Remove duplicates (if any)
    final uniqueFavorites = updatedFavorites.toSet().toList();

    // Save the updated list
    final favoritesJson = uniqueFavorites.map((movie) => movie.toJson()).toList();
    await prefs.setString('favorites', jsonEncode(favoritesJson));
  }

  List<Movie> getFavoriteMovies() {
    final favoritesJson = prefs.getString('favorites');
    if (favoritesJson != null) {
      final List<dynamic> jsonList = jsonDecode(favoritesJson);
      final favorites = jsonList.map((json) => Movie.fromJson(json)).toList();
      return favorites;
    }
    return [];
  }
}