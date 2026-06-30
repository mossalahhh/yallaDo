import 'package:flutter/material.dart';
import 'package:yallado/core/network/token_storage.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/features/auth/data/auth_service.dart';
import 'package:yallado/features/child/views/change_password.dart';
import 'package:yallado/features/child/views/profile.dart';
import 'package:yallado/features/child/views/widgets/link_code_dialog.dart';
import 'package:yallado/features/splash/views/onboarding.dart';

import 'change_email.dart';

class SettingScreenChild extends StatefulWidget {
  const SettingScreenChild({super.key});

  @override
  State<SettingScreenChild> createState() => _SettingScreenChildState();
}

class _SettingScreenChildState extends State<SettingScreenChild> {
  bool isNotificationOn = true;

  void _showLinkCodeDialog(BuildContext rootContext) =>
      showLinkCodeDialog(rootContext);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColor.secondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Setting",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColor.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SettingItem(
                icon: Icons.person_outline,
                title: "Account",
                subtitle: "Edit Profile",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreenChild(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              SettingItem(
                icon: Icons.person_outline,
                title: "Account",
                subtitle: "Change Email",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ChangeEmailChild()),
                ),
              ),

              SettingItem(
                icon: null,
                title: "",
                subtitle: "Change Password",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ChangePasswordChild()),
                ),
              ),

              const SizedBox(height: 20),

              SettingItem(
                icon: Icons.notifications_none,
                title: "Notification",
                subtitle: isNotificationOn ? "On" : "Off",
                trailing: Switch(
                  value: isNotificationOn,
                  activeColor: AppColor.secondary,
                  onChanged: (value) {
                    setState(() {
                      isNotificationOn = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              SettingItem(
                icon: Icons.link,
                title: "Family Code",
                subtitle: "Link your account",
                onTap: () => _showLinkCodeDialog(context),
              ),

              const SizedBox(height: 20),

              SettingItem(
                icon: Icons.language,
                title: "App Language",
                subtitle: "English",
                onTap: () {},
              ),

              const SizedBox(height: 20),

              SettingItem(
                icon: Icons.logout,
                title: "Logout",
                subtitle: "",
                showArrow: false,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text(
                        "Logout",
                        style: TextStyle(
                          color: AppColor.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                        "Are you sure you want to logout?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await AuthService().logout();
                            await TokenStorage.clear();
                            if (!context.mounted) return;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const OnboardingScreen()),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool showArrow;
  final VoidCallback? onTap;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.showArrow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, color: AppColor.secondary, size: 26)
          else
            const SizedBox(width: 26),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColor.secondary,
                    ),
                  ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),

          if (trailing != null)
            trailing!
          else if (showArrow)
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              onPressed: onTap,
            ),
        ],
      ),
    );
  }
}