import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/Movie.dart';


class LocalDataSource {
  final SharedPreferences prefs;

  LocalDataSource({required this.prefs});

  Future<void> saveFavoriteMovies(List<Movie> movies) async {
    final favorites = movies.where((movie) => movie.isFavorite).toList();
    final favoritesJson = favorites.map((movie) => movie.toJson()).toList();
    await prefs.setString('favorites', jsonEncode(favoritesJson));
  }

  List<Movie> getFavoriteMovies() {
    final favoritesJson = prefs.getString('favorites');
    if (favoritesJson != null) {
      final List<dynamic> jsonList = jsonDecode(favoritesJson);
      return jsonList.map((json) => Movie.fromJson(json)).toList();
    }
    return [];
  }
}