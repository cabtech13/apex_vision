import 'package:flutter/foundation.dart';
import 'package:iptv_magik_app/data/models/playlist.dart';
import 'package:iptv_magik_app/data/repositories/playlist_repository.dart';

class PlaylistViewModel extends ChangeNotifier {
  final PlaylistRepository _repository;

  List<Playlist> _playlists = [];
  List<Playlist> get playlists => _playlists;

  Playlist? _activePlaylist;
  Playlist? get activePlaylist => _activePlaylist;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PlaylistViewModel(this._repository) {
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    _isLoading = true;
    notifyListeners();

    _playlists = _repository.getAllPlaylists();
    _activePlaylist = _repository.getActivePlaylist();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPlaylist(
    String name,
    String url, {
    String type = 'm3u',
    String? username,
    String? password,
  }) async {
    await _repository.addPlaylist(
      name,
      url,
      type: type,
      username: username,
      password: password,
    );
    await _loadPlaylists();
  }

  Future<void> setActivePlaylist(String id) async {
    await _repository.setActivePlaylist(id);
    await _loadPlaylists();
  }

  Future<void> deletePlaylist(String id) async {
    await _repository.deletePlaylist(id);
    await _loadPlaylists();
  }
}
