import 'package:hive_flutter/hive_flutter.dart';
import 'package:iptv_magik_app/data/models/playlist.dart';
import 'package:uuid/uuid.dart';

class PlaylistRepository {
  static const String boxName = 'playlists';
  final Box<Playlist> _box;

  PlaylistRepository(this._box);

  static Future<PlaylistRepository> init() async {
    final box = await Hive.openBox<Playlist>(boxName);
    return PlaylistRepository(box);
  }

  // Create
  Future<void> addPlaylist(
    String name,
    String url, {
    String type = 'm3u',
    String? username,
    String? password,
  }) async {
    final newPlaylist = Playlist(
      id: const Uuid().v4(),
      name: name,
      url: url,
      type: type,
      username: username,
      password: password,
      isActive: _box.isEmpty, // First one is active by default
    );
    await _box.add(newPlaylist);
  }

  // Read
  List<Playlist> getAllPlaylists() {
    return _box.values.toList();
  }

  Playlist? getActivePlaylist() {
    try {
      return _box.values.firstWhere((p) => p.isActive);
    } catch (e) {
      if (_box.isNotEmpty) {
        // Fallback: set first as active
        final first = _box.values.first;
        first.isActive = true;
        first.save();
        return first;
      }
      return null;
    }
  }

  // Update
  Future<void> setActivePlaylist(String id) async {
    for (var playlist in _box.values) {
      if (playlist.id == id) {
        playlist.isActive = true;
      } else {
        playlist.isActive = false;
      }
      await playlist.save();
    }
  }

  Future<void> updatePlaylist(Playlist playlist) async {
    await playlist.save();
  }

  // Delete
  Future<void> deletePlaylist(String id) async {
    final playlistToDelete = _box.values.firstWhere((p) => p.id == id);
    await playlistToDelete.delete();
  }
}
