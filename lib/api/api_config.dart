class ApiConfig {
  static const String baseUrl = 'http://139.180.185.59:8090';
  static const String apiVersion = 'v1';
  
  // API endpoints
  static const String login = '/api/auth/login';
  static const String signup = '/api/auth/signup';
  static const String logout = '/api/auth/logout';
  
  // API headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // API timeout
  static const int connectTimeout = 5; // seconds
  static const int receiveTimeout = 3; // seconds
} 