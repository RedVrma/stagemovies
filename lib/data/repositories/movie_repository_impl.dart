
import 'package:stagemovies/data/datasources/local_data_source.dart';

import '../../core/network/movie_api_service.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieApiService apiService;
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