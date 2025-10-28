import 'package:frontend_flutter/frontend.dart';

class TodoService implements TodoRepo {
  final Dio _dio = DioClient.instance.dio;

  @override
  Future<TodoModel> createTodo(TodoModel todoModel) async {
    try {
      final response = await _dio.post(
        ApiConstants.todosEndpoint,
        data: todoModel.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final todo = TodoModel.fromJson(data['todo'] as Map<String, dynamic>);
        return todo;
      } else {
        throw GeneralException(message: 'Failed to create todo');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<TodoModel?> deleteTodo(int id) async {
    try {
      final response = await _dio.delete('${ApiConstants.todosEndpoint}/$id');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final todo = TodoModel.fromJson(data['todo'] as Map<String, dynamic>);
        return todo;
      } else {
        throw GeneralException(message: 'Failed to delete todo');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<List<TodoModel>> getAllTodos() async {
    try {
      final response = await _dio.get(ApiConstants.todosEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final todosList = (data['data'] as List)
            .map((json) => TodoModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return todosList;
      } else {
        throw GeneralException(message: 'Failed to fetch todos');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<TodoModel?> getTodo(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.todosEndpoint}/$id');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final todo = TodoModel.fromJson(data['data'] as Map<String, dynamic>);
        return todo;
      } else {
        throw GeneralException(message: 'Failed to fetch todo');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel updatedTodoModel) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.todosEndpoint}/${updatedTodoModel.id}',
        data: updatedTodoModel.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final todo = TodoModel.fromJson(data['data'] as Map<String, dynamic>);
        return todo;
      } else {
        throw GeneralException(message: 'Failed to update todo');
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
