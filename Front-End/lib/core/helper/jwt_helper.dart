import 'dart:convert';

/// Minimal JWT payload decoder.
///
/// The YallaDo login endpoint returns only a token; the user's role
/// (`parent` / `child`) is embedded in the JWT payload, so we decode it locally
/// to drive post-login routing without an extra network call.
abstract class JwtHelper {
  static Map<String, dynamic> decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return {};
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = jsonDecode(decoded);
      return map is Map<String, dynamic> ? map : {};
    } catch (_) {
      return {};
    }
  }

  static String? roleFromToken(String token) =>
      decodePayload(token)['role'] as String?;
}
