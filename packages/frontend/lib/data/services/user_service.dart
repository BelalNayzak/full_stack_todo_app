import 'package:frontend_flutter/frontend.dart';

class UserService implements UserRepo {
  final Dio _dio = DioClient.instance.dio;

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _dio.get(ApiConstants.usersEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final usersList = (data['data'] as List)
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return usersList;
      } else {
        throw GeneralException(message: 'Failed to fetch users');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUser(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.usersEndpoint}/$id');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final user = UserModel.fromJson(data['data'] as Map<String, dynamic>);
        return user;
      } else {
        throw GeneralException(message: 'Failed to fetch user');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<UserModel> addUser(UserModel userModel) async {
    try {
      final response = await _dio.post(
        ApiConstants.usersEndpoint,
        data: userModel.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        return user;
      } else {
        throw GeneralException(message: 'Failed to create user');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> deleteUser(int id) async {
    try {
      final response = await _dio.delete('${ApiConstants.usersEndpoint}/$id');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final user = UserModel.fromJson(data['data'] as Map<String, dynamic>);
        return user;
      } else {
        throw GeneralException(message: 'Failed to delete user');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<UserModel> updateUser(UserModel updatedUserModel) async {
    try {
      final response = await _dio.put(
        ApiConstants.usersEndpoint,
        data: updatedUserModel.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        return user;
      } else {
        throw GeneralException(message: 'Failed to update user');
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
