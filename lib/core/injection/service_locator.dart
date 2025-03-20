// lib/core/injection/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stagemovies/presentation/screens/cubit/homepage_cubit.dart';

import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../network/movie_api_service.dart';


final GetIt sl = GetIt.instance;

Future<void> initDependencyInjection() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Core
  sl.registerLazySingleton<MovieApiService>(() => MovieApiService());

  // Data sources
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSource(prefs: sl()));

  // Repositories
  sl.registerLazySingleton<MovieRepository>(
        () => MovieRepositoryImpl(apiService: sl(),localDataSource: sl()),
  );

  // Cubits
  sl.registerFactory<HomepageCubit>(
        () => HomepageCubit(movieRepository: sl(), localDataSource: sl()),
  );
}