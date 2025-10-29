import 'package:frontend_flutter/frontend.dart';

class AuthService implements AuthRepo {
  final Dio _dio = DioClient.instance.dio;

  @override
  Future<UserModel> register(UserModel userModel) async {
    try {
      final response = await _dio.post(
        ApiConstants.registerEndpoint,
        data: userModel.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final user = UserModel.fromJson(data['data'] as Map<String, dynamic>);
        return user;
      } else {
        throw GeneralException(message: 'Failed to register.');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<String?> login(UserModel userModel) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: userModel.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final String token = data['data'];
        return token;
      } else {
        throw GeneralException(message: 'Login Failed.');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _dio.post(ApiConstants.logoutEndpoint);
      if (response.statusCode == 200) {
        return;
      } else {
        throw GeneralException(message: 'Logout Failed.');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  ///

  NetworkException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        return ServerException(
          message: 'Server error: ${e.response?.statusCode}',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'Connection error');
      default:
        return UnknownException(message: e.message ?? 'Unknown error');
    }
  }
}
