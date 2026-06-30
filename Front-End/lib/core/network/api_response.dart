import 'package:dio/dio.dart';

class ApiResponse {
  final bool status;
  final int statusCode;
  final dynamic data;
  final String message;

  ApiResponse({
    required this.status,
    required this.statusCode,
    this.data,
    required this.message,
  });

  // Factory method to handle Dio responses
  factory ApiResponse.fromResponse(Response response) {
    final data = response.data;
    // The YallaDo backend wraps every payload in `{ "success": bool, ... }`.
    // (The claim endpoint misspells the key as "sucess" — accept both so a
    // successful claim isn't reported as a failure.)
    final bool success =
        data is Map && (data["success"] == true || data["sucess"] == true);
    return ApiResponse(
      status: success,
      statusCode: response.statusCode ?? 500,
      data: data,
      message: (data is Map ? data["message"] : null) ?? '',
    );
  }

  // Factory method to handle Dio or other exceptions
  factory ApiResponse.fromError(dynamic error) {
    // ignore: avoid_print
    print(error.toString());
    if (error is DioException) {
      // ignore: avoid_print
      return ApiResponse(
        status: false,
        data: error.response?.data,
        statusCode:
        error.response?.statusCode ?? 500 ,
        message: _handleDioError(error),
      );
    } else {
      return ApiResponse(
        status: false,
        statusCode: 500,
        message: 'An error occurred.',
      );
    }
  }
  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout, please try again.";
      case DioExceptionType.sendTimeout:
        return "Send timeout, please check your internet.";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout, please try again later.";
      case DioExceptionType.badResponse:
        return _handleServerError(error.response);
      case DioExceptionType.cancel:
        return "Request was cancelled.";
      case DioExceptionType.connectionError:
        return "No internet connection.";
      default:
        return "Unknown error occurred.";
    }
  }

  /// Handling errors from the server response
  static String _handleServerError(Response? response) {
    if (response == null) return "No response from server.";
    final int code = response.statusCode ?? 0;
    // 5xx are server-side crashes/bugs — never surface the raw Node.js message
    // (e.g. "Cannot read properties of undefined (reading 'images')") to users.
    // The real message is still logged by the Dio interceptor for developers.
    if (code >= 500) {
      // ignore: avoid_print
      print("----- Server 5xx: ${response.data}");
      return "Something went wrong on the server. Please try again later.";
    }
    if (response.data is Map && response.data["message"] != null) {
      return response.data["message"].toString();
    }
    return "An error occurred.";
  }
}