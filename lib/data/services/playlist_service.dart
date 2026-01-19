import 'package:dio/dio.dart';
import 'package:iptv_magik_app/data/models/playlist.dart';
import 'package:iptv_magik_app/data/models/channel.dart';
import 'package:iptv_magik_app/core/utils/m3u_parser.dart';
import 'package:iptv_magik_app/core/utils/logger.dart';

class PlaylistService {
  final Dio _dio;

  PlaylistService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Channel>> fetchPlaylist(Playlist playlist) async {
    String fetchUrl = playlist.url;

    if (playlist.type == 'xtream') {
      fetchUrl = _constructXtreamUrl(playlist);
    }

    try {
      final response = await _dio.get(fetchUrl);

      if (response.statusCode == 200) {
        return await M3UParser.parse(response.data.toString());
      } else {
        throw Exception('Failed to load playlist: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('PlaylistService: Error fetching playlist', e);
      rethrow;
    }
  }

  Future<bool> validateConnection(Playlist playlist) async {
    try {
      await fetchPlaylist(playlist);
      return true;
    } catch (e) {
      return false;
    }
  }

  String _constructXtreamUrl(Playlist playlist) {
    // Basic construction: http://url:port/get.php?username=...&password=...&type=m3u_plus&output=ts
    // Ensure url doesn't end with /
    String baseUrl = playlist.url;
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    return '$baseUrl/get.php?username=${playlist.username}&password=${playlist.password}&type=m3u_plus&output=ts';
  }
}
