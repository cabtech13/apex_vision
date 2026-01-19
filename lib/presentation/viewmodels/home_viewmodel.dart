import 'package:flutter/foundation.dart';
import 'package:iptv_magik_app/data/models/channel.dart';
import 'package:iptv_magik_app/data/models/vod_content.dart';
import 'package:iptv_magik_app/data/models/tmdb_metadata.dart';
import 'package:iptv_magik_app/data/repositories/playlist_repository.dart';
import 'package:iptv_magik_app/data/services/playlist_service.dart';
import 'package:iptv_magik_app/data/repositories/tmdb_repository.dart';
import 'package:iptv_magik_app/core/utils/logger.dart';

class HomeViewModel extends ChangeNotifier {
  final PlaylistRepository _playlistRepository;
  final PlaylistService _playlistService;
  final TMDBRepository _tmdbRepository;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Channel> _allChannels = [];
  List<Channel> _popularChannels = [];
  List<Channel> get popularChannels => _popularChannels;

  Map<String, List<Channel>> _categoriesWithChannels = {};
  Map<String, List<Channel>> get categoriesWithChannels =>
      _categoriesWithChannels;

  List<VODContent> _newMovies = [];
  List<VODContent> get newMovies => _newMovies;

  HomeViewModel({
    required PlaylistRepository playlistRepository,
    required PlaylistService playlistService,
    required TMDBRepository tmdbRepository,
  }) : _playlistRepository = playlistRepository,
       _playlistService = playlistService,
       _tmdbRepository = tmdbRepository {
    loadHomeContent();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> loadHomeContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final activePlaylist = _playlistRepository.getActivePlaylist();
      if (activePlaylist != null) {
        Logger.log('Chargement de la playlist: ${activePlaylist.name}');
        _allChannels = await _playlistService.fetchPlaylist(activePlaylist);

        // Catégorisation simple
        _categoriesWithChannels = {};
        _newMovies = []; // Réinitialiser

        for (var channel in _allChannels) {
          final cat = channel.category.toUpperCase();
          if (!_categoriesWithChannels.containsKey(channel.category)) {
            _categoriesWithChannels[channel.category] = [];
          }
          _categoriesWithChannels[channel.category]!.add(channel);

          // Si la catégorie semble être des films, on en prend quelques-uns pour "Nouveaux Films"
          if (_newMovies.length < 15 &&
              (cat.contains('MOVIE') || cat.contains('FILM'))) {
            _newMovies.add(
              VODContent(
                id: channel.id,
                title: channel.name,
                type: VODType.movie,
                streamUrl: channel.streamUrl,
                posterUrl: channel.logoUrl,
              ),
            );
          }
        }

        // Simuler des chaines "populaires"
        _popularChannels = _allChannels.take(10).toList();
      } else {
        Logger.log('Aucune playlist active trouvée.');
        _allChannels = [];
        _popularChannels = [];
        _categoriesWithChannels = {};
        _newMovies = [];
      }
    } catch (e) {
      Logger.error('Erreur lors du chargement du contenu Home', e);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Récupère les métadonnées TMDB pour un contenu
  Future<TMDBMetadata?> getVODMetadata(
    String title, {
    bool isMovie = true,
  }) async {
    return await _tmdbRepository.searchContent(title, isMovie: isMovie);
  }

  Future<List<TMDBMetadata>> getSimilar(int id, {bool isMovie = true}) async {
    return await _tmdbRepository.getSimilar(id, isMovie: isMovie);
  }
}
