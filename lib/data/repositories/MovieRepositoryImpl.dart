
import 'package:stagemovies/data/datasources/LocalDataSource.dart';

import '../../core/network/MoviesApiService.dart';
import '../../domain/entities/Movie.dart';
import '../../domain/repositories/MovieRepository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ApiService apiService;
  final LocalDataSource localDataSource;

  MovieRepositoryImpl({required this.apiService, required this.localDataSource});

  @override
  Future<List<Movie>> getMovies() async {
    try {
      // Fetch movies from the API
      final data = await apiService.getMovies();

      // Map JSON data to Movie objects
      final movies = (data['results'] as List).map((movie) {
        return Movie.fromJson(movie);
      }).toList();

      final favoriteMovies = localDataSource.getFavoriteMovies();

      // Update the `isFavorite` flag for each movie
      final updatedMovies = movies.map((movie) {
        final isFavorite = favoriteMovies.any((fav) => fav.id == movie.id);
        return movie.copyWith(isFavorite: isFavorite);
      }).toList();

      return updatedMovies;
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    final data = await apiService.searchMovies(query);
    return (data['results'] as List).map((movie) => Movie.fromJson(movie)).toList();
  }
}