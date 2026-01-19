/// Modèle pour les métadonnées TMDB
class TMDBMetadata {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final double voteAverage;
  final String? releaseDate;
  final List<String> genres;
  final List<Cast> cast;

  TMDBMetadata({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    required this.voteAverage,
    this.releaseDate,
    this.genres = const [],
    this.cast = const [],
  });

  factory TMDBMetadata.fromJson(Map<String, dynamic> json) {
    return TMDBMetadata(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      overview: json['overview'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? json['first_air_date'],
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((g) => g['name'] as String)
              .toList() ??
          [],
      cast:
          (json['credits']?['cast'] as List<dynamic>?)
              ?.take(5)
              .map((c) => Cast.fromJson(c))
              .toList() ??
          [],
    );
  }

  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  String? get backdropUrl =>
      backdropPath != null
          ? 'https://image.tmdb.org/t/p/original$backdropPath'
          : null;

  int? get year {
    if (releaseDate == null) return null;
    return int.tryParse(releaseDate!.substring(0, 4));
  }
}

/// Modèle pour un membre du casting
class Cast {
  final String name;
  final String? character;
  final String? profilePath;

  Cast({required this.name, this.character, this.profilePath});

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'] ?? '',
      character: json['character'],
      profilePath: json['profile_path'],
    );
  }

  String? get profileUrl =>
      profilePath != null
          ? 'https://image.tmdb.org/t/p/w185$profilePath'
          : null;
}
