class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://192.168.2.226:3000/api/v1/';

  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Endpoints
  // Add your API endpoints here
  static const String spaces = 'spaces';
  static const String storages = 'storages';
  static const String items = 'items';

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
}
