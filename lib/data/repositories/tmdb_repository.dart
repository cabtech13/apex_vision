import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/logger.dart';
import '../models/tmdb_metadata.dart';

class TMDBRepository {
  final Dio _dio = Dio();

  Future<TMDBMetadata?> searchContent(
    String query, {
    bool isMovie = true,
  }) async {
    if (ApiConstants.tmdbApiKey.isEmpty) {
      Logger.log('TMDB API Key est vide. Mode démo activé.');
      return null;
    }

    try {
      final endpoint = isMovie ? '/search/movie' : '/search/tv';
      final response = await _dio.get(
        '${ApiConstants.tmdbBaseUrl}$endpoint',
        queryParameters: {
          'api_key': ApiConstants.tmdbApiKey,
          'query': _cleanQuery(query),
          'language': 'fr-FR',
        },
      );

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        if (results.isNotEmpty) {
          return TMDBMetadata.fromJson(results.first);
        }
      }
    } catch (e) {
      Logger.error('Erreur TMDB Search ($query)', e);
    }
    return null;
  }

  Future<List<TMDBMetadata>> getSimilar(int id, {bool isMovie = true}) async {
    if (ApiConstants.tmdbApiKey.isEmpty) return [];

    try {
      final endpoint = isMovie ? '/movie/$id/similar' : '/tv/$id/similar';
      final response = await _dio.get(
        '${ApiConstants.tmdbBaseUrl}$endpoint',
        queryParameters: {
          'api_key': ApiConstants.tmdbApiKey,
          'language': 'fr-FR',
        },
      );

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.take(10).map((e) => TMDBMetadata.fromJson(e)).toList();
      }
    } catch (e) {
      Logger.error('Erreur TMDB Similar ($id)', e);
    }
    return [];
  }

  /// Nettoie le nom de la chaîne pour une meilleure recherche
  /// (Ex: "FR | CANAL PLUZ 4K" -> "Canal Plus")
  String _cleanQuery(String query) {
    // Supprimer les tags courants
    String cleaned = query.toUpperCase();
    cleaned = cleaned.replaceAll(RegExp(r'\[.*?\]'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\(.*?\)'), '');
    cleaned = cleaned.replaceAll('FR |', '');
    cleaned = cleaned.replaceAll('FR:', '');
    cleaned = cleaned.replaceAll('FR -', '');
    cleaned = cleaned.replaceAll('FHD', '');
    cleaned = cleaned.replaceAll('HD', '');
    cleaned = cleaned.replaceAll('SD', '');
    cleaned = cleaned.replaceAll('4K', '');
    cleaned = cleaned.replaceAll('UHD', '');
    cleaned = cleaned.replaceAll('|', '');

    return cleaned.trim();
  }
}
