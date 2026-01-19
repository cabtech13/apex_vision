/// Constantes API pour les services externes
class ApiConstants {
  // TMDB API
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String tmdbPosterSize = 'w500';
  static const String tmdbBackdropSize = 'original';

  // REMPLACER PAR VOTRE CLÉ API TMDB
  static const String tmdbApiKey = '';

  // Remote Config (à remplacer par votre endpoint)
  static const String remoteConfigUrl =
      'LOCAL'; // Si LOCAL, utilise assets/sample_data/config.json

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Cache
  static const Duration cacheDuration = Duration(days: 7);
}
