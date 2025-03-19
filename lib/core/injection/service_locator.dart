// lib/core/injection/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stagemovies/presentation/screens/cubit/homepage_cubit.dart';

import '../../data/datasources/LocalDataSource.dart';
import '../../data/repositories/MovieRepositoryImpl.dart';
import '../../domain/repositories/MovieRepository.dart';
import '../network/MoviesApiService.dart';


final GetIt sl = GetIt.instance;

Future<void> initDependencyInjection() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Core
  sl.registerLazySingleton<ApiService>(() => ApiService());

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