import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_exception.dart';
import '../models/create_user_dto.dart';

class UserService {
  final Dio _dio = DioClient.instance.dio;

  Future<ApiResponse<List<UserModel>>> getAllUsers() async {
    try {
      final response = await _dio.get(ApiConstants.usersEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final usersList = (data['data'] as List)
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return ApiResponse.success(
          message: data['message'] as String,
          data: usersList,
        );
      } else {
        return ApiResponse.error(message: 'Failed to fetch users');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  Future<ApiResponse<UserModel>> getUserById(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.usersEndpoint}/$id');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final user = UserModel.fromJson(data['data'] as Map<String, dynamic>);

        return ApiResponse.success(
          message: data['message'] as String,
          data: user,
        );
      } else {
        return ApiResponse.error(message: 'Failed to fetch user');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  Future<ApiResponse<UserModel>> createUser(CreateUserDto createUserDto) async {
    try {
      final response = await _dio.post(
        ApiConstants.usersEndpoint,
        data: createUserDto.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

        return ApiResponse.success(
          message: data['message'] as String,
          data: user,
        );
      } else {
        return ApiResponse.error(message: 'Failed to create user');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

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
