import 'package:hive/hive.dart';

part 'channel.g.dart';

/// Modèle représentant une chaîne IPTV
@HiveType(typeId: 0)
class Channel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String streamUrl;

  @HiveField(3)
  final String? logoUrl;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final int? tvgId; // EPG ID pour XMLTV

  @HiveField(6)
  final String? groupTitle; // Groupe M3U

  @HiveField(7)
  final bool isFavorite;

  @HiveField(8)
  final DateTime? lastWatched;

  Channel({
    required this.id,
    required this.name,
    required this.streamUrl,
    this.logoUrl,
    required this.category,
    this.tvgId,
    this.groupTitle,
    this.isFavorite = false,
    this.lastWatched,
  });

  /// Factory pour créer depuis JSON
  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      streamUrl: json['streamUrl'] ?? '',
      logoUrl: json['logoUrl'],
      category: json['category'] ?? 'Général',
      tvgId: json['tvgId'],
      groupTitle: json['groupTitle'],
      isFavorite: json['isFavorite'] ?? false,
      lastWatched:
          json['lastWatched'] != null
              ? DateTime.parse(json['lastWatched'])
              : null,
    );
  }

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'streamUrl': streamUrl,
      'logoUrl': logoUrl,
      'category': category,
      'tvgId': tvgId,
      'groupTitle': groupTitle,
      'isFavorite': isFavorite,
      'lastWatched': lastWatched?.toIso8601String(),
    };
  }

  /// CopyWith pour modifications immutables
  Channel copyWith({
    String? id,
    String? name,
    String? streamUrl,
    String? logoUrl,
    String? category,
    int? tvgId,
    String? groupTitle,
    bool? isFavorite,
    DateTime? lastWatched,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      streamUrl: streamUrl ?? this.streamUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      category: category ?? this.category,
      tvgId: tvgId ?? this.tvgId,
      groupTitle: groupTitle ?? this.groupTitle,
      isFavorite: isFavorite ?? this.isFavorite,
      lastWatched: lastWatched ?? this.lastWatched,
    );
  }
}
