import 'package:flutter/material.dart';

/// Navigation helpers shared across screens.
class AppNav {
  AppNav._();

  /// Pops the current route if there is something to go back to; otherwise
  /// runs [fallback] (e.g. route to a home screen). Several screens are opened
  /// with `pushReplacement`, which leaves the back stack empty — a plain
  /// `Navigator.pop` there does nothing, which is why "back" felt broken.
  static void back(BuildContext context, {VoidCallback? fallback}) {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else if (fallback != null) {
      fallback();
    }
  }
}
