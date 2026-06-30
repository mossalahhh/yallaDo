import 'package:yallado/core/helper/jwt_helper.dart';

/// Typed view over the JWT returned by `auth/login`.
class AuthToken {
  final String raw;
  final String email;
  final String id;
  final String role;

  const AuthToken({
    required this.raw,
    required this.email,
    required this.id,
    required this.role,
  });

  factory AuthToken.fromJwt(String token) {
    final payload = JwtHelper.decodePayload(token);
    return AuthToken(
      raw: token,
      email: (payload['email'] ?? '') as String,
      id: (payload['id'] ?? '') as String,
      role: (payload['role'] ?? '') as String,
    );
  }

  bool get isParent => role == 'parent';
  bool get isChild => role == 'child';
}
