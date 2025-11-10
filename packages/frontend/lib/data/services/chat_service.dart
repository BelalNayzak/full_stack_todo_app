import 'package:frontend_flutter/frontend.dart';

class ChatService {
  final Dio _dio = DioClient.instance.dio;

  Future<ChatResponse> sendMessage({
    required String message,
    required int userId,
  }) async {
    try {
      final response = await _dio.post(
        '/chat_with_data',
        data: {
          'message': message,
          'user_id': userId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return ChatResponse(
          message: data['message'] as String,
          data: data['data'] as List<dynamic>?,
        );
      } else {
        throw GeneralException(message: 'Failed to send message');
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

class ChatResponse {
  final String message;
  final List<dynamic>? data;

  ChatResponse({
    required this.message,
    this.data,
  });
}
