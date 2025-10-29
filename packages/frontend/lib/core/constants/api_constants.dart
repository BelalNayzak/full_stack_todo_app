class ApiConstants {
  static const String baseUrl = 'http://localhost:8080';

  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';

  static const String usersEndpoint = '/user';
  static const String todosEndpoint = '/todo';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
