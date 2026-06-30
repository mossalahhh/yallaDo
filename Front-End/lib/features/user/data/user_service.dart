import 'package:image_picker/image_picker.dart';
import 'package:yallado/core/network/api_helper.dart';
import 'package:yallado/core/network/api_response.dart';
import 'package:yallado/core/network/upload_helper.dart';

/// Data layer for Module 2 (User Profile). All requests are protected
/// (the custom `yallaDo_grad_` token is attached by [ApiHelper]).
class UserService {
  final ApiHelper _api = ApiHelper();

  Future<ApiResponse> _safe(Future<ApiResponse> Function() call) async {
    try {
      return await call();
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> getProfile() {
    return _safe(() => _api.getRequest(endPoint: 'user/me', isProtected: true));
  }

  /// PATCH `user/profile` — name and userName are both optional.
  Future<ApiResponse> updateProfile({String? name, String? userName}) {
    return _safe(
      () => _api.patchRequest(
        endPoint: 'user/profile',
        isProtected: true,
        data: {
          if (name != null && name.isNotEmpty) 'name': name,
          if (userName != null && userName.isNotEmpty) 'userName': userName,
        },
      ),
    );
  }

  /// PUT `user/update-avatar` — multipart; the file field key is `avatar`.
  /// Web-safe (uploads bytes via [multipartFromXFile]).
  Future<ApiResponse> updateAvatar(XFile image) {
    return _safe(() async {
      final multipart = await multipartFromXFile(image);
      return _api.putRequest(
        endPoint: 'user/update-avatar',
        isProtected: true,
        isFormData: true,
        data: {'avatar': multipart},
      );
    });
  }

  Future<ApiResponse> deleteAvatar() {
    return _safe(() => _api.deleteRequest(
          endPoint: 'user/delete-avatar',
          isProtected: true,
        ));
  }

  /// POST `user/change-email` — sends a confirmation code to the new email.
  Future<ApiResponse> changeEmail({
    required String newEmail,
    required String password,
  }) {
    return _safe(
      () => _api.postRequest(
        endPoint: 'user/change-email',
        isProtected: true,
        data: {'newEmail': newEmail, 'password': password},
      ),
    );
  }

  /// PATCH `user/confirm-email` — confirms the pending email change.
  Future<ApiResponse> confirmEmail({required String code}) {
    return _safe(
      () => _api.patchRequest(
        endPoint: 'user/confirm-email',
        isProtected: true,
        data: {'code': code},
      ),
    );
  }

  /// PATCH `user/update-password`.
  Future<ApiResponse> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _safe(
      () => _api.patchRequest(
        endPoint: 'user/update-password',
        isProtected: true,
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      ),
    );
  }
}
