import 'package:image_picker/image_picker.dart';
import 'package:yallado/core/network/api_helper.dart';
import 'package:yallado/core/network/api_response.dart';
import 'package:yallado/core/network/upload_helper.dart';

/// Data layer for Module 6 (Rewards Engine). All requests are protected.
class RewardService {
  final ApiHelper _api = ApiHelper();

  Future<ApiResponse> _safe(Future<ApiResponse> Function() call) async {
    try {
      return await call();
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> getRewards() {
    return _safe(
        () => _api.getRequest(endPoint: 'reward/rewards', isProtected: true));
  }

  /// POST `reward/add` — multipart; optional image field is `rewardImg`.
  Future<ApiResponse> addReward({
    required String name,
    required int points,
    int? quantity,
    String? description,
    XFile? image,
  }) {
    return _safe(() async {
      final data = <String, dynamic>{
        'name': name,
        'points': '$points',
        if (quantity != null) 'quantity': '$quantity',
        if (description != null && description.isNotEmpty)
          'description': description,
        if (image != null) 'rewardImg': await multipartFromXFile(image),
      };
      return _api.postRequest(
          endPoint: 'reward/add',
          isProtected: true,
          isFormData: true,
          data: data);
    });
  }

  /// PATCH `reward/:id/update` (JSON) — allows name, points, description, quantity.
  Future<ApiResponse> updateReward({
    required String id,
    String? name,
    int? points,
    String? description,
    int? quantity,
  }) {
    return _safe(() => _api.patchRequest(
          endPoint: 'reward/$id/update',
          isProtected: true,
          data: {
            if (name != null && name.isNotEmpty) 'name': name,
            if (points != null) 'points': points,
            if (description != null) 'description': description,
            if (quantity != null) 'quantity': quantity,
          },
        ));
  }

  Future<ApiResponse> deleteReward(String id) {
    return _safe(() => _api.patchRequest(
        endPoint: 'reward/$id/delete', isProtected: true));
  }

  Future<ApiResponse> deactivate(String id) {
    return _safe(() => _api.patchRequest(
        endPoint: 'reward/$id/deactivate', isProtected: true));
  }

  Future<ApiResponse> reactivate(String id) {
    return _safe(() => _api.patchRequest(
        endPoint: 'reward/$id/reactivate', isProtected: true));
  }

  /// PATCH `reward/:id/redeem` (child).
  Future<ApiResponse> redeem(String id) {
    return _safe(() => _api.patchRequest(
        endPoint: 'reward/$id/redeem', isProtected: true));
  }
}
