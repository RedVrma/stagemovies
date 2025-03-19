import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));

  Future<Map<String, dynamic>> getMovies() async {
    try {
      final response = await _dio.get('movie/popular', queryParameters: {
        'api_key': 'a40ce2fb87b05f9de06b4ae95ef0315a',
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> searchMovies(String query) async {
    try {
      final response = await _dio.get('search/movie', queryParameters: {
        'api_key': 'a40ce2fb87b05f9de06b4ae95ef0315a',
        'query': query,
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to search movies');
    }
  }
}