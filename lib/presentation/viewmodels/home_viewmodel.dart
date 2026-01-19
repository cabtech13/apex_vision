import 'package:flutter/foundation.dart';
import 'package:iptv_magik_app/data/models/channel.dart';
import 'package:iptv_magik_app/data/models/vod_content.dart';
import 'package:iptv_magik_app/data/repositories/playlist_repository.dart';
import 'package:iptv_magik_app/data/services/playlist_service.dart';
import 'package:iptv_magik_app/core/utils/logger.dart';

class HomeViewModel extends ChangeNotifier {
  final PlaylistRepository _playlistRepository;
  final PlaylistService _playlistService;

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
  }) : _playlistRepository = playlistRepository,
       _playlistService = playlistService {
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
        for (var channel in _allChannels) {
          final cat = channel.category;
          if (!_categoriesWithChannels.containsKey(cat)) {
            _categoriesWithChannels[cat] = [];
          }
          _categoriesWithChannels[cat]!.add(channel);
        }

        // Simuler des chaines "populaires" (les 10 premières par exemple)
        _popularChannels = _allChannels.take(10).toList();
      } else {
        Logger.log('Aucune playlist active trouvée.');
        _allChannels = [];
        _popularChannels = [];
        _categoriesWithChannels = {};
      }
    } catch (e) {
      Logger.error('Erreur lors du chargement du contenu Home', e);
    }

    _isLoading = false;
    notifyListeners();
  }
}
