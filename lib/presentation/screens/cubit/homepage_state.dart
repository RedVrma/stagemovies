part of 'homepage_cubit.dart';

abstract class HomepageState extends Equatable {
  const HomepageState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends HomepageState {}

class MovieLoading extends HomepageState {}

class MovieLoaded extends HomepageState {
  final List<Movie> movies;

  const MovieLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class MovieError extends HomepageState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object?> get props => [message];
}