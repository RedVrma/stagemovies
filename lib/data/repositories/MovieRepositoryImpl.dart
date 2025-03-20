
import 'package:stagemovies/data/datasources/LocalDataSource.dart';

import '../../core/network/MoviesApiService.dart';
import '../../domain/entities/Movie.dart';
import '../../domain/repositories/MovieRepository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MoviesApiService apiService;
  final LocalDataSource localDataSource;

  MovieRepositoryImpl({required this.apiService, required this.localDataSource});

  @override
  Future<List<Movie>> getMovies() async {
    final data = await apiService.getMovies();
    return (data['results'] as List).map((movie) => Movie.fromJson(movie)).toList();
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    final data = await apiService.searchMovies(query);
    return (data['results'] as List).map((movie) => Movie.fromJson(movie)).toList();
  }
}