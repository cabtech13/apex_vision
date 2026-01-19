class TMDBMetadata {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String? releaseDate;
  final List<String> genres;

  TMDBMetadata({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    this.releaseDate,
    required this.genres,
  });

  factory TMDBMetadata.fromJson(Map<String, dynamic> json) {
    return TMDBMetadata(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? 'Unknown',
      overview: json['overview'] ?? 'No overview available.',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] ?? json['first_air_date'],
      genres: [], // Will be populated separately or via mapping
    );
  }

  String get fullPosterUrl =>
      posterPath != null
          ? 'https://image.tmdb.org/t/p/w500$posterPath'
          : 'https://via.placeholder.com/500x750?text=$title';

  String get fullBackdropUrl =>
      backdropPath != null
          ? 'https://image.tmdb.org/t/p/original$backdropPath'
          : 'https://via.placeholder.com/1920x1080?text=$title';
}
