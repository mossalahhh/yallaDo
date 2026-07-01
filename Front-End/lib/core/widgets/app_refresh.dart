import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';

/// Wraps a scrollable screen body in a branded pull-to-refresh.
///
/// The inner scrollable must allow over-scroll even when its content is short,
/// so use `physics: const AlwaysScrollableScrollPhysics()` on the ListView /
/// SingleChildScrollView inside [child]; otherwise the pull gesture won't fire
/// on pages that don't fill the screen.
class AppRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const AppRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColor.secondary,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
