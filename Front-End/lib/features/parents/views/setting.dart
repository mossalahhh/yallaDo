import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/features/parents/views/change_password.dart';
import 'package:yallado/features/parents/views/profile.dart';
import 'package:yallado/features/parents/views/widgets/unlink_bottomsheet.dart';
import 'change_email.dart';
import 'widgets/setting_item.dart';
import 'widgets/logout_dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _notificationsEnabled = true;

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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
              ),

              const SizedBox(height: 20),

              SettingItem(
                icon: Icons.email_outlined,
                title: "Account",
                subtitle: "Change Email",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangeEmail()),
                ),
              ),

              SettingItem(
                icon: Icons.lock_outline,
                title: "Account",
                subtitle: "Change Password",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordEdit()),
                ),
              ),

              const SizedBox(height: 20),

              SettingItem(
                icon: Icons.notifications_none,
                title: "Notification",
                subtitle: _notificationsEnabled ? "On" : "Off",
                trailing: Switch(
                  value: _notificationsEnabled,
                  activeColor: AppColor.secondary,
                  onChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                    // TODO: save preference / call notification service
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── Language ──
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
                onTap: () => showLogoutDialog(context),
              ),

              const SizedBox(height: 20),

              SettingItem(
                icon: Icons.link_off,
                title: "Unlink child",
                subtitle: "",
                showArrow: false,
                onTap: () => showUnlinkSheet(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}