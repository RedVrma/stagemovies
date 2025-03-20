import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MoviesApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));

  Future<Map<String, dynamic>> getMovies() async {
    try {
      final response = await _dio.get('movie/popular', queryParameters: {
        'api_key': dotenv.env['TMDB_API_KEY'],
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> searchMovies(String query) async {
    try {
      final response = await _dio.get('search/movie', queryParameters: {
        'api_key': dotenv.env['TMDB_API_KEY'],
        'query': query,
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to search movies');
    }
  }
}