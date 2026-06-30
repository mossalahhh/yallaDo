import 'package:dio/dio.dart';
import 'api_response.dart';
import 'end_points.dart';
import 'token_storage.dart';


class ApiHelper {
  // singleton
  static final ApiHelper _instance = ApiHelper._init();
  factory ApiHelper() {
    _instance.initDio();
    return _instance;
  }
  ApiHelper._init();

  bool _interceptorsAttached = false;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: EndPoints.baseURL,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  void initDio() {
    if (_interceptorsAttached) return;
    _interceptorsAttached = true;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // ignore: avoid_print
          print("--- [${options.method}] ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // ignore: avoid_print
          print("--- Response: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          // ignore: avoid_print
          print("--- Error: ${error.response?.statusCode} ${error.response?.data}");
          return handler.next(error);
        },
      ),
    );
  }

  /// Builds the headers map, attaching the custom auth token when [isProtected].
  Future<Map<String, dynamic>> _headers(bool isProtected) async {
    if (!isProtected) return {};
    final token = await TokenStorage.getToken();
    return {
      if (token != null && token.isNotEmpty)
        'Authorization': '${EndPoints.tokenPrefix}$token',
    };
  }

  Future<ApiResponse> postRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    return ApiResponse.fromResponse(
      await dio.post(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(headers: await _headers(isProtected)),
      ),
    );
  }

  Future<ApiResponse> getRequest({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    bool isProtected = false,
  }) async {
    return ApiResponse.fromResponse(
      await dio.get(
        endPoint,
        queryParameters: queryParameters,
        options: Options(headers: await _headers(isProtected)),
      ),
    );
  }

  Future<ApiResponse> putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    return ApiResponse.fromResponse(
      await dio.put(
        endPoint,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(headers: await _headers(isProtected)),
      ),
    );
  }

  Future<ApiResponse> patchRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    return ApiResponse.fromResponse(
      await dio.patch(
        endPoint,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(headers: await _headers(isProtected)),
      ),
    );
  }

  Future<ApiResponse> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    return ApiResponse.fromResponse(
      await dio.delete(
        endPoint,
        queryParameters: queryParameters,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(headers: await _headers(isProtected)),
      ),
    );
  }
}
