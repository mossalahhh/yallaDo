import 'package:yallado/core/network/api_helper.dart';
import 'package:yallado/core/network/api_response.dart';

/// Data layer for Module 7 (AI chat). `POST ai/chat` is a child feature
/// (parents get 403); body field is `prompt`, response field is `reply`.
class AiService {
  final ApiHelper _api = ApiHelper();

  Future<ApiResponse> chat(String prompt) async {
    try {
      return await _api.postRequest(
        endPoint: 'ai/chat',
        isProtected: true,
        data: {'prompt': prompt},
      );
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }
}
