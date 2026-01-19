import 'package:dio/dio.dart';
import 'package:iptv_magik_app/core/utils/logger.dart';

class RemoteConfigRepository {
  final Dio _dio;

  RemoteConfigRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> fetchRemoteConfig(String url) async {
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load remote config: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('RemoteConfigRepository: Error fetching config', e);
      rethrow;
    }
  }

  // Fallback / Mock for development if no URL provided
  Future<Map<String, dynamic>> getMockConfig() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      "playlists": [
        {
          "name": "Flux TV Mock",
          "url":
              "https://iptv-org.github.io/iptv/index.m3u", // Example public playlist
        },
      ],
    };
  }
}
