import 'package:hive/hive.dart';

part 'playlist.g.dart';

@HiveType(typeId: 4)
class Playlist extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final String? username; // For Xtream Codes

  @HiveField(4)
  final String? password; // For Xtream Codes

  @HiveField(5)
  bool isActive;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final String type; // 'm3u' or 'xtream'

  Playlist({
    required this.id,
    required this.name,
    required this.url,
    this.username,
    this.password,
    this.isActive = false,
    required this.type,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isXtream => type == 'xtream';
}
