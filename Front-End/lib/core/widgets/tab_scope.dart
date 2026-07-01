import 'package:flutter/material.dart';

/// Lets a screen that lives inside a bottom-nav [IndexedStack] jump back to the
/// Home tab. A plain `Navigator.pop` does nothing on a tab (the tab is not its
/// own route), which is why "back" felt broken on the Tasks / Profile /
/// Notifications / Rewards tabs. The bottom nav provides [goHome]; tab screens
/// call it as their back-button fallback.
class TabScope extends InheritedWidget {
  final VoidCallback goHome;

  const TabScope({
    super.key,
    required this.goHome,
    required super.child,
  });

  static TabScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TabScope>();

  @override
  bool updateShouldNotify(TabScope oldWidget) => false;
}
