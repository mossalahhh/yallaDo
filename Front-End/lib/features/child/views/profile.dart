import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/app_network_image.dart';
import 'package:yallado/features/child/views/child_avatar_view.dart';
import 'package:yallado/features/child/views/setting.dart';
import 'package:yallado/features/user/cubit/profile_cubit/profile_cubit.dart';
import 'package:yallado/features/user/cubit/profile_cubit/profile_state.dart';
import 'package:yallado/features/user/data/models/user_model.dart';

class ProfileScreenChild extends StatelessWidget {
  const ProfileScreenChild({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadProfile(),
      child: const _ProfileChildBody(),
    );
  }
}

class _ProfileChildBody extends StatelessWidget {
  const _ProfileChildBody();

  Future<void> _editName(BuildContext context, UserProfile profile) async {
    final cubit = context.read<ProfileCubit>();
    final nameController = TextEditingController(text: profile.user.name);
    final userNameController =
        TextEditingController(text: profile.user.userName);
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFF9F7F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Profile",
            style: TextStyle(
                color: AppColor.secondary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(labelText: "User Name"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColor.secondary),
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.updateProfile(
                name: nameController.text.trim(),
                userName: userNameController.text.trim(),
              );
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F0),
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileActionSuccess) {
              SnackBarPopUp().show(
                  context: context,
                  message: state.message,
                  state: PopUpState.success);
            } else if (state is ProfileActionError || state is ProfileError) {
              final msg = state is ProfileActionError
                  ? state.message
                  : (state as ProfileError).message;
              SnackBarPopUp().show(
                  context: context, message: msg, state: PopUpState.error);
            }
          },
          builder: (context, state) {
            final profile = context.read<ProfileCubit>().profile;
            if (profile == null) {
              return Center(
                child: state is ProfileError
                    ? Text(state.message,
                        style: const TextStyle(color: AppColor.secondary))
                    : const CircularProgressIndicator(
                        color: AppColor.secondary),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: AppColor.secondary),
                      ),
                      const SizedBox(width: 10),
                      const Text("Profile",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColor.secondary)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AppAvatar(
                                url: profile.user.avatarUrl, radius: 48),
                            Positioned(
                              bottom: -10,
                              right: -10,
                              child: IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ChildAvatarView()),
                                ),
                                icon: const Icon(Icons.camera_alt_outlined,
                                    color: AppColor.secondary, size: 25),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _editName(context, profile),
                          child: const Text("Edit",
                              style: TextStyle(
                                  color: AppColor.secondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ProfileInfoItem(
                      icon: Icons.child_care_outlined,
                      title: "Name",
                      value: profile.user.name),
                  const SizedBox(height: 30),
                  ProfileInfoItem(
                      icon: Icons.alternate_email,
                      title: "User Name",
                      value: profile.user.userName),
                  const SizedBox(height: 30),
                  ProfileInfoItem(
                      icon: Icons.mail_outline,
                      title: "Email",
                      value: profile.user.email),
                  const SizedBox(height: 30),
                  ProfileInfoItem(
                      icon: Icons.person_outline,
                      title: "Parent",
                      value: profile.parentNames.isEmpty
                          ? "—"
                          : profile.parentNames.join(", ")),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SettingScreenChild()),
                    ),
                    child: const ProfileInfoItem(
                        icon: Icons.settings, title: "Setting", value: " "),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColor.secondary),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.secondary)),
              const SizedBox(height: 5),
              Text(value,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.grey, height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}
