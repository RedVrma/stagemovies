import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/datasources/LocalDataSource.dart';
import '../../../domain/entities/Movie.dart';
import '../../../domain/repositories/MovieRepository.dart';

part 'homepage_state.dart';

class HomepageCubit extends Cubit<HomepageState> {
  final MovieRepository movieRepository;
  final LocalDataSource localDataSource;

  HomepageCubit({required this.movieRepository, required this.localDataSource})
      : super(MovieInitial());

  Future<void> fetchMovies() async {
    emit(MovieLoading());
    try {
      final movies = await movieRepository.getMovies();
      final favoriteMovies = localDataSource.getFavoriteMovies();
      final updatedMovies = movies.map((movie) {
        final isFavorite = favoriteMovies.any((fav) => fav.id == movie.id);
        return movie.copyWith(isFavorite: isFavorite);
      }).toList();
      emit(MovieLoaded(updatedMovies));
    } catch (e) {
      emit(MovieError('Failed to load movies'));
    }
  }

  Future<void> searchMovies(String query) async {
    emit(MovieLoading());
    try {
      final movies = await movieRepository.searchMovies(query);
      final favoriteMovies = localDataSource.getFavoriteMovies();
      final updatedMovies = movies.map((movie) {
        final isFavorite = favoriteMovies.any((fav) => fav.id == movie.id);
        return movie.copyWith(isFavorite: isFavorite);
      }).toList();
      emit(MovieLoaded(updatedMovies));
    } catch (e) {
      emit(MovieError('Failed to search movies'));
    }
  }

  void toggleFavorite(Movie movie) {
    final state = this.state;
    if (state is MovieLoaded) {
      final updatedMovies = state.movies.map((m) {
        if (m.id == movie.id) {
          return m.copyWith(isFavorite: !m.isFavorite);
        }
        return m;
      }).toList();
      localDataSource.saveFavoriteMovies(updatedMovies);
      emit(MovieLoaded(updatedMovies));
    }
  }
}