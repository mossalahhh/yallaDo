import 'package:yallado/core/network/api_helper.dart';
import 'package:yallado/core/network/api_response.dart';

/// Data layer for Module 3 (Parent Actions). All requests are protected.
class ParentService {
  final ApiHelper _api = ApiHelper();

  Future<ApiResponse> _safe(Future<ApiResponse> Function() call) async {
    try {
      return await call();
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> getChildren() {
    return _safe(
        () => _api.getRequest(endPoint: 'parent/children', isProtected: true));
  }

  Future<ApiResponse> getChildDetails(String childId) {
    return _safe(() =>
        _api.getRequest(endPoint: 'parent/$childId/details', isProtected: true));
  }

  Future<ApiResponse> getChildHistory(String childId, {int page = 1}) {
    return _safe(() => _api.getRequest(
          endPoint: 'parent/$childId/history',
          isProtected: true,
          queryParameters: {'page': page},
        ));
  }

  /// POST `parent/:id/adjust-points` — [type] is `add` or `remove`.
  Future<ApiResponse> adjustPoints({
    required String childId,
    required String type,
    required int points,
    required String reason,
  }) {
    return _safe(() => _api.postRequest(
          endPoint: 'parent/$childId/adjust-points',
          isProtected: true,
          data: {'type': type, 'points': points, 'reason': reason},
        ));
  }

  Future<ApiResponse> unlinkChild(String childId) {
    return _safe(() => _api.deleteRequest(
        endPoint: 'parent/$childId/unlink', isProtected: true));
  }

  Future<ApiResponse> generateInviteCode() {
    return _safe(() =>
        _api.postRequest(endPoint: 'parent/invite-code', isProtected: true));
  }

  /// GET `parent/progress-completion` → per-child approved-task percentage.
  Future<ApiResponse> getProgressCompletion() {
    return _safe(() => _api.getRequest(
        endPoint: 'parent/progress-completion', isProtected: true));
  }

  /// GET `parent/category-completion` → completion rate per category.
  Future<ApiResponse> getCategoryCompletion() {
    return _safe(() => _api.getRequest(
        endPoint: 'parent/category-completion', isProtected: true));
  }

  /// GET `parent/analytics-points?range=` → points over time (weekly/monthly/daily).
  Future<ApiResponse> getPointsAnalytics(String range) {
    return _safe(() => _api.getRequest(
          endPoint: 'parent/analytics-points',
          isProtected: true,
          queryParameters: {'range': range},
        ));
  }
}
