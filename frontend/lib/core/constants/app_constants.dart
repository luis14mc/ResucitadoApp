class AppConstants {
  // App Information
  static const String appName = 'Parroquia Cristo Resucitado';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'pcr_app.db';
  static const int databaseVersion = 1;

  // SharedPreferences Keys
  static const String userPreferences = 'user_preferences';
  static const String themePreferences = 'theme_preferences';
  static const String cachePreferences = 'cache_preferences';

  // Cache Keys
  static const String santosCacheKey = 'santos_cache';
  static const String eventosCacheKey = 'eventos_cache';
  static const String horariosCacheKey = 'horarios_cache';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Date Formats
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String displayDateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';

  // Social Media URLs
  static const String facebookUrl = 'https://facebook.com/parroquiaresucitado';
  static const String instagramUrl =
      'https://instagram.com/parroquiaresucitado';
  static const String twitterUrl = 'https://twitter.com/parroquiaresuc';
  static const String youtubeUrl = 'https://youtube.com/@parroquiaresucitado';
  static const String whatsappUrl = 'https://wa.me/573123456789';

  // Contact Information
  static const String phoneNumber = '+57 312 345 6789';
  static const String email = 'info@parroquiaresucitado.com';
  static const String address = 'Calle 123 #45-67, Bogotá, Colombia';

  // Error Messages
  static const String noInternetError = 'No hay conexión a internet';
  static const String serverError = 'Error del servidor. Inténtalo más tarde';
  static const String timeoutError = 'Tiempo de espera agotado';
  static const String unknownError = 'Error desconocido';
}
