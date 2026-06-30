import 'package:shared_preferences/shared_preferences.dart';

/// Single source of truth for the persisted auth token.
///
/// This backend has no refresh-token flow, so we persist only the raw JWT
/// returned by `auth/login`. The `yallaDo_grad_` prefix is applied at request
/// time inside [ApiHelper], never stored.
abstract class TokenStorage {
  static const String _kToken = 'token';

  static Future<void> saveToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kToken, token);
  }

  static Future<String?> getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kToken);
  }

  static Future<bool> hasToken() async => (await getToken())?.isNotEmpty ?? false;

  static Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kToken);
  }
}
