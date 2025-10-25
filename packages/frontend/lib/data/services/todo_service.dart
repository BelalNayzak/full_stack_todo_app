import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_exception.dart';
import '../models/create_todo_dto.dart';
import '../models/update_todo_dto.dart';

class TodoService {
  final Dio _dio = DioClient.instance.dio;

  Future<ApiResponse<List<TodoModel>>> getAllTodos() async {
    try {
      final response = await _dio.get(ApiConstants.todosEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final todosList = (data['data'] as List)
            .map((json) => TodoModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return ApiResponse.success(
          message: data['message'] as String,
          data: todosList,
        );
      } else {
        return ApiResponse.error(message: 'Failed to fetch todos');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  Future<ApiResponse<TodoModel>> getTodoById(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.todosEndpoint}/$id');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final todo = TodoModel.fromJson(data['data'] as Map<String, dynamic>);

        return ApiResponse.success(
          message: data['message'] as String,
          data: todo,
        );
      } else {
        return ApiResponse.error(message: 'Failed to fetch todo');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  Future<ApiResponse<TodoModel>> createTodo(CreateTodoDto createTodoDto) async {
    try {
      final response = await _dio.post(
        ApiConstants.todosEndpoint,
        data: createTodoDto.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final todo = TodoModel.fromJson(data['todo'] as Map<String, dynamic>);

        return ApiResponse.success(
          message: data['message'] as String,
          data: todo,
        );
      } else {
        return ApiResponse.error(message: 'Failed to create todo');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  Future<ApiResponse<TodoModel>> updateTodo(UpdateTodoDto updateTodoDto) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.todosEndpoint}/${updateTodoDto.id}',
        data: updateTodoDto.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final todo = TodoModel.fromJson(data['todo'] as Map<String, dynamic>);

        return ApiResponse.success(
          message: data['message'] as String,
          data: todo,
        );
      } else {
        return ApiResponse.error(message: 'Failed to update todo');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  Future<ApiResponse<TodoModel>> deleteTodo(int id) async {
    try {
      final response = await _dio.delete('${ApiConstants.todosEndpoint}/$id');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final todo = TodoModel.fromJson(data['todo'] as Map<String, dynamic>);

        return ApiResponse.success(
          message: data['message'] as String,
          data: todo,
        );
      } else {
        return ApiResponse.error(message: 'Failed to delete todo');
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
