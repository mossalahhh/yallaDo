import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/app_error_retry.dart';
import 'package:yallado/features/child/cubit/avatar_cubit/avatar_cubit.dart';
import 'package:yallado/features/child/cubit/avatar_cubit/avatar_state.dart';
import 'package:yallado/features/child/data/models/avatar_model.dart';
import 'package:yallado/features/child/views/widgets/avatar.dart';

class ChildAvatarView extends StatelessWidget {
  const ChildAvatarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AvatarCubit()..load(),
      child: const _ChildAvatarBody(),
    );
  }
}

class _ChildAvatarBody extends StatefulWidget {
  const _ChildAvatarBody();

  @override
  State<_ChildAvatarBody> createState() => _ChildAvatarBodyState();
}

class _ChildAvatarBodyState extends State<_ChildAvatarBody> {
  final PageController _controller = PageController(viewportFraction: 1.0);
  int currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirmBuy(BuildContext context, AvatarModel avatar, AvatarCubit cubit) {
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        backgroundColor: const Color(0xFFF9F7F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Buy Avatar",
            style: TextStyle(
                color: AppColor.secondary, fontWeight: FontWeight.bold)),
        content: Text(
            "Unlock \"${avatar.title}\" for ${avatar.pointsRequired} points?\nYou have ${cubit.points} points.",
            style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColor.secondary),
            onPressed: () {
              Navigator.pop(dctx);
              cubit.selectAvatar(avatar.avatarId);
            },
            child: const Text("Buy", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/avatarbackgroung.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocConsumer<AvatarCubit, AvatarState>(
          listener: (context, state) {
            if (state is AvatarSelected) {
              SnackBarPopUp().show(
                  context: context,
                  message: state.message,
                  state: PopUpState.success);
            } else if (state is AvatarSelectError || state is AvatarError) {
              final msg = state is AvatarSelectError
                  ? state.message
                  : (state as AvatarError).message;
              SnackBarPopUp().show(
                  context: context, message: msg, state: PopUpState.error);
            }
          },
          builder: (context, state) {
            final cubit = context.read<AvatarCubit>();
            final avatars = cubit.avatars;

            if (avatars.isEmpty) {
              return state is AvatarError
                  ? AppErrorRetry(
                      message: state.message,
                      onRetry: () => context.read<AvatarCubit>().load(),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                          color: AppColor.secondary),
                    );
            }

            final current = avatars[currentIndex.clamp(0, avatars.length - 1)];
            final bool busy = state is AvatarSelecting;

            return Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.deepPurple),
                      ),
                      Text(
                        "${cubit.points} 💰",
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 220),
                Text(
                  current.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColor.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 240,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AvatarArrow(
                        isLeft: true,
                        enabled: currentIndex > 0,
                        onTap: () => _controller.animateToPage(
                          currentIndex - 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: avatars.length,
                          onPageChanged: (index) =>
                              setState(() => currentIndex = index),
                          itemBuilder: (context, index) {
                            return AvatarItem(
                              image: avatars[index].imageUrl,
                              isActive: index == currentIndex,
                              locked: avatars[index].isLocked,
                            );
                          },
                        ),
                      ),
                      AvatarArrow(
                        isLeft: false,
                        enabled: currentIndex < avatars.length - 1,
                        onTap: () => _controller.animateToPage(
                          currentIndex + 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.secondary,
                      minimumSize: const Size(180, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: (current.isSelected || busy)
                        ? null
                        : () {
                            if (current.isLocked) {
                              _confirmBuy(context, current, cubit);
                            } else {
                              cubit.selectAvatar(current.avatarId);
                            }
                          },
                    child: busy
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
                            current.isSelected
                                ? 'Selected'
                                : current.isLocked
                                    ? 'Buy (${current.pointsRequired} ⭐)'
                                    : 'Select',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
