import 'package:yallado/core/network/api_helper.dart';
import 'package:yallado/core/network/api_response.dart';
import 'package:yallado/core/network/end_points.dart';

/// Data layer for Module 1 (Auth). Every method returns a normalized
/// [ApiResponse]; transport errors are converted via [ApiResponse.fromError]
/// so callers (cubits) never deal with raw [DioException]s.
class AuthService {
  final ApiHelper _api = ApiHelper();

  Future<ApiResponse> _safe(Future<ApiResponse> Function() call) async {
    try {
      return await call();
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> register({
    required String name,
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
    required String gender,
    required String dateOfBirth,
    required String role,
  }) {
    return _safe(
      () => _api.postRequest(
        endPoint: EndPoints.register,
        data: {
          'name': name,
          'userName': userName,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'gender': gender,
          'dateOfBirth': dateOfBirth,
          'role': role,
        },
      ),
    );
  }

  Future<ApiResponse> login({
    required String email,
    required String password,
  }) {
    return _safe(
      () => _api.postRequest(
        endPoint: EndPoints.login,
        data: {'email': email, 'password': password},
      ),
    );
  }

  Future<ApiResponse> verifyEmail({
    required String email,
    required String activationCode,
  }) {
    return _safe(
      () => _api.postRequest(
        endPoint: EndPoints.verifyEmail,
        data: {'email': email, 'activationCode': activationCode},
      ),
    );
  }

  /// [type] must be `activationCode` (email confirmation) or `forgetPassword`
  /// (password reset). These are the only values the backend accepts.
  Future<ApiResponse> resendCode({
    required String email,
    required String type,
  }) {
    return _safe(
      () => _api.postRequest(
        endPoint: EndPoints.resendCode,
        data: {'email': email, 'type': type},
      ),
    );
  }

  Future<ApiResponse> forgetPassword({required String email}) {
    return _safe(
      () => _api.postRequest(
        endPoint: EndPoints.forgetPassword,
        data: {'email': email},
      ),
    );
  }

  Future<ApiResponse> resetPassword({
    required String email,
    required String resetCode,
    required String newPassword,
  }) {
    return _safe(
      () => _api.postRequest(
        endPoint: EndPoints.resetPassword,
        data: {
          'email': email,
          'resetCode': resetCode,
          'newPassword': newPassword,
        },
      ),
    );
  }

  Future<ApiResponse> logout() {
    return _safe(
      () => _api.deleteRequest(
        endPoint: EndPoints.logout,
        isProtected: true,
      ),
    );
  }
}
