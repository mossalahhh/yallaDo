import 'package:shared_preferences/shared_preferences.dart';

/// Small app-level flags (e.g. whether the intro onboarding has been seen).
abstract class AppPrefs {
  static const String _kSeenOnboarding = 'seen_onboarding';

  static Future<bool> seenOnboarding() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kSeenOnboarding) ?? false;
  }

  static Future<void> setSeenOnboarding() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kSeenOnboarding, true);
  }
}
