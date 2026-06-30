import 'package:yallado/core/network/api_helper.dart';
import 'package:yallado/core/network/api_response.dart';

/// Data layer for Module 4 (Children Actions). All requests are protected.
class ChildService {
  final ApiHelper _api = ApiHelper();

  Future<ApiResponse> _safe(Future<ApiResponse> Function() call) async {
    try {
      return await call();
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  /// POST `child/link-accounts` — links this child to a parent via family code.
  Future<ApiResponse> linkAccount(String code) {
    return _safe(() => _api.postRequest(
          endPoint: 'child/link-accounts',
          isProtected: true,
          data: {'code': code},
        ));
  }

  Future<ApiResponse> getMyPoints() {
    return _safe(() =>
        _api.getRequest(endPoint: 'child/my-points', isProtected: true));
  }

  Future<ApiResponse> getAvatars() {
    return _safe(
        () => _api.getRequest(endPoint: 'child/avatars', isProtected: true));
  }

  /// GET `child/top-children` → `{myRank, top3:[...]}`.
  Future<ApiResponse> getTopChildren() {
    return _safe(() =>
        _api.getRequest(endPoint: 'child/top-children', isProtected: true));
  }

  /// POST `child/:avatarId/select`.
  Future<ApiResponse> selectAvatar(String avatarId) {
    return _safe(() => _api.postRequest(
          endPoint: 'child/$avatarId/select',
          isProtected: true,
        ));
  }
}
