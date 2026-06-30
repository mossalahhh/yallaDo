import 'package:flutter/material.dart';
import 'package:yallado/core/network/token_storage.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/features/auth/data/auth_service.dart';
import 'package:yallado/features/splash/views/onboarding.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color(0xFFF9F7F0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Log Out",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColor.secondary,
        ),
      ),
      content: const Text(
        "Are you sure you want to log out?",
        style: TextStyle(color: Colors.grey),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            // Best-effort server logout, then always clear the local session.
            await AuthService().logout();
            await TokenStorage.clear();
            if (!context.mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const OnboardingScreen()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.secondary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text("Log Out", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
