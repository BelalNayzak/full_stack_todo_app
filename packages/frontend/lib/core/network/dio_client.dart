import 'package:frontend_flutter/frontend.dart';

class DioClient {
  static DioClient? _instance;
  late Dio _dio;

  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.addAll([
      RequestsInspectorInterceptor(),
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    ]);
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  /// update headers with token
  void updateTokenInHeaders(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Dio get dio => _dio;
}
