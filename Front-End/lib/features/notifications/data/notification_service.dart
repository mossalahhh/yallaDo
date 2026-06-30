import 'package:yallado/core/network/api_helper.dart';
import 'package:yallado/core/network/api_response.dart';

/// Data layer for Module 7 (Notifications). All requests are protected.
class NotificationService {
  final ApiHelper _api = ApiHelper();

  Future<ApiResponse> _safe(Future<ApiResponse> Function() call) async {
    try {
      return await call();
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> getNotifications() {
    return _safe(
        () => _api.getRequest(endPoint: 'notifications', isProtected: true));
  }

  /// GET `notifications/count` → total notification count (for the badge).
  Future<ApiResponse> count() {
    return _safe(() =>
        _api.getRequest(endPoint: 'notifications/count', isProtected: true));
  }

  Future<ApiResponse> readOne(String id) {
    return _safe(() => _api.patchRequest(
        endPoint: 'notifications/$id/read', isProtected: true));
  }

  Future<ApiResponse> readAll() {
    return _safe(() => _api.patchRequest(
        endPoint: 'notifications/readall', isProtected: true));
  }

  Future<ApiResponse> deleteOne(String id) {
    return _safe(() => _api.deleteRequest(
        endPoint: 'notifications/$id/delete', isProtected: true));
  }

  Future<ApiResponse> deleteAll() {
    return _safe(() => _api.deleteRequest(
        endPoint: 'notifications/deleteall', isProtected: true));
  }
}
