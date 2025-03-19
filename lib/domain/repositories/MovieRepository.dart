

import '../entities/Movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovies();

  Future<List<Movie>> searchMovies(String query);
}