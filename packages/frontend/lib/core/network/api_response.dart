// class ApiResponse<T> {
//   final bool success;
//   final String message;
//   final T? data;
//   final String? error;

//   const ApiResponse({
//     required this.success,
//     required this.message,
//     this.data,
//     this.error,
//   });

//   factory ApiResponse.success({required String message, required T data}) {
//     return ApiResponse<T>(success: true, message: message, data: data);
//   }

//   factory ApiResponse.error({required String message, String? error}) {
//     return ApiResponse<T>(success: false, message: message, error: error);
//   }

//   @override
//   String toString() {
//     return 'ApiResponse(success: $success, message: $message, data: $data, error: $error)';
//   }
// }
