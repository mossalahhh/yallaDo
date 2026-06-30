import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';

enum PopUpState { success, error, warning, info }

abstract class AppPopUp {
  void show({
    required BuildContext context,
    required String message,
    required PopUpState state,
  });

  SnackBarStyle getStyle(PopUpState state) {
    switch (state) {
      case PopUpState.success:
        return SnackBarStyle(
          backgroundColor: Colors.green.shade600,
          icon: Icons.check_circle,
          iconColor: Colors.white,
        );
      case PopUpState.error:
        return SnackBarStyle(
          backgroundColor: Colors.red.shade600,
          icon: Icons.error,
          iconColor: Colors.white,
        );
      case PopUpState.warning:
        return SnackBarStyle(
          backgroundColor: Colors.orange.shade700,
          icon: Icons.warning,
          iconColor: Colors.white,
        );
      case PopUpState.info:
      default:
        return SnackBarStyle(
          backgroundColor: Colors.blue.shade600,
          icon: Icons.info,
          iconColor: Colors.white,
        );
    }
  }
}

class SnackBarStyle {
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  SnackBarStyle({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  });
}

class SnackBarPopUp extends AppPopUp {
  @override
  void show({
    required BuildContext context,
    required String message,
    required PopUpState state,
  }) {
    final style = getStyle(state);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: style.backgroundColor,
        content: Row(
          children: [
            Icon(style.icon, color: style.iconColor),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

// bottom sheet
class AppBottomSheet {
  static void show({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    bool isScrollControlled = true,
  }) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      isScrollControlled: isScrollControlled,
      backgroundColor: AppColor.white,
      context: context,
      builder: builder,
    );
  }
}