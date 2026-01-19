import 'package:hive/hive.dart';

part 'vod_content.g.dart';

/// Type de contenu VOD
@HiveType(typeId: 3)
enum VODType {
  @HiveField(0)
  movie,

  @HiveField(1)
  series,
}

/// Modèle représentant un contenu VOD (Film ou Série)
@HiveType(typeId: 2)
class VODContent {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final VODType type;

  @HiveField(3)
  final String streamUrl;

  @HiveField(4)
  final String? posterUrl; // TMDB poster

  @HiveField(5)
  final String? backdropUrl; // TMDB backdrop

  @HiveField(6)
  final String? overview; // Synopsis TMDB

  @HiveField(7)
  final double? rating; // Note TMDB (0-10)

  @HiveField(8)
  final int? year; // Année de sortie

  @HiveField(9)
  final List<String>? genres; // ["Action", "Thriller"]

  @HiveField(10)
  final int? tmdbId; // ID TMDB pour enrichissement

  @HiveField(11)
  final bool isFavorite;

  @HiveField(12)
  final int? continueAt; // Position en secondes pour reprise

  @HiveField(13)
  final DateTime? lastWatched;

  VODContent({
    required this.id,
    required this.title,
    required this.type,
    required this.streamUrl,
    this.posterUrl,
    this.backdropUrl,
    this.overview,
    this.rating,
    this.year,
    this.genres,
    this.tmdbId,
    this.isFavorite = false,
    this.continueAt,
    this.lastWatched,
  });

  factory VODContent.fromJson(Map<String, dynamic> json) {
    return VODContent(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] == 'series' ? VODType.series : VODType.movie,
      streamUrl: json['streamUrl'] ?? '',
      posterUrl: json['posterUrl'],
      backdropUrl: json['backdropUrl'],
      overview: json['overview'],
      rating: json['rating']?.toDouble(),
      year: json['year'],
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
      tmdbId: json['tmdbId'],
      isFavorite: json['isFavorite'] ?? false,
      continueAt: json['continueAt'],
      lastWatched:
          json['lastWatched'] != null
              ? DateTime.parse(json['lastWatched'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type == VODType.series ? 'series' : 'movie',
      'streamUrl': streamUrl,
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl,
      'overview': overview,
      'rating': rating,
      'year': year,
      'genres': genres,
      'tmdbId': tmdbId,
      'isFavorite': isFavorite,
      'continueAt': continueAt,
      'lastWatched': lastWatched?.toIso8601String(),
    };
  }

  VODContent copyWith({
    String? id,
    String? title,
    VODType? type,
    String? streamUrl,
    String? posterUrl,
    String? backdropUrl,
    String? overview,
    double? rating,
    int? year,
    List<String>? genres,
    int? tmdbId,
    bool? isFavorite,
    int? continueAt,
    DateTime? lastWatched,
  }) {
    return VODContent(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      streamUrl: streamUrl ?? this.streamUrl,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      overview: overview ?? this.overview,
      rating: rating ?? this.rating,
      year: year ?? this.year,
      genres: genres ?? this.genres,
      tmdbId: tmdbId ?? this.tmdbId,
      isFavorite: isFavorite ?? this.isFavorite,
      continueAt: continueAt ?? this.continueAt,
      lastWatched: lastWatched ?? this.lastWatched,
    );
  }
}
