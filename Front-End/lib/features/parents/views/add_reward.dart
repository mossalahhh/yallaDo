import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yallado/core/helper/app_nav.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/tab_scope.dart';
import 'package:yallado/features/parents/views/rewards.dart';
import 'package:yallado/features/parents/views/widgets/widget.dart';
import 'package:yallado/features/rewards/cubit/rewards_cubit/rewards_cubit.dart';
import 'package:yallado/features/rewards/cubit/rewards_cubit/rewards_state.dart';

class AddRewardScreen extends StatelessWidget {
  const AddRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RewardsCubit(),
      child: const _AddRewardBody(),
    );
  }
}

class _AddRewardBody extends StatefulWidget {
  const _AddRewardBody();

  @override
  State<_AddRewardBody> createState() => _AddRewardBodyState();
}

class _AddRewardBodyState extends State<_AddRewardBody> {
  final _nameController = TextEditingController();
  final _pointsController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  XFile? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _pointsController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) setState(() => _image = picked);
  }

  void _onAdd(BuildContext context) {
    final name = _nameController.text.trim();
    final points = int.tryParse(_pointsController.text.trim());
    if (name.isEmpty) {
      _warn(context, "Please enter a reward name");
      return;
    }
    if (points == null || points < 1) {
      _warn(context, "Please enter valid points");
      return;
    }
    context.read<RewardsCubit>().addReward(
          name: name,
          points: points,
          quantity: int.tryParse(_quantityController.text.trim()),
          description: _descriptionController.text.trim(),
          image: _image,
        );
  }

  void _warn(BuildContext context, String msg) => SnackBarPopUp()
      .show(context: context, message: msg, state: PopUpState.warning);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RewardsCubit, RewardsState>(
      listener: (context, state) {
        if (state is RewardActionSuccess) {
          SnackBarPopUp().show(
              context: context,
              message: state.message,
              state: PopUpState.success);
          _nameController.clear();
          _pointsController.clear();
          _quantityController.clear();
          setState(() => _image = null);
        } else if (state is RewardActionError) {
          SnackBarPopUp().show(
              context: context,
              message: state.message,
              state: PopUpState.error);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F7F0),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => AppNav.back(context,
                          fallback: () => TabScope.of(context)?.goHome()),
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColor.secondary),
                    ),
                  ),
                  Image.asset('images/hero.png', height: 60, width: 60),
                  const Text("Add Reward",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColor.secondary)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Our Store",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColor.secondary)),
                      TextButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ParentRewards()),
                        ),
                        icon: const Icon(Icons.storefront,
                            color: AppColor.secondary, size: 20),
                        label: const Text("View all",
                            style: TextStyle(color: AppColor.secondary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RewardCard(
                          title: "Rewards",
                          bottomColor: const Color(0xffFFD6A5),
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const ParentRewards()))),
                      RewardCard(
                          title: "Manage",
                          bottomColor: const Color(0xffF9A0B2),
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const ParentRewards()))),
                      RewardCard(
                          title: "Store",
                          bottomColor: const Color(0xffB5EA99),
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const ParentRewards()))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _label("Reward Name"),
                  const SizedBox(height: 10),
                  _field(_nameController),
                  const SizedBox(height: 20),
                  _label("Description"),
                  const SizedBox(height: 10),
                  _field(_descriptionController, maxLines: 3),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label("Points"),
                            const SizedBox(height: 10),
                            _field(_pointsController,
                                keyboard: TextInputType.number),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label("Quantity"),
                            const SizedBox(height: 10),
                            _field(_quantityController,
                                keyboard: TextInputType.number),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _label("Image (optional)"),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.camera_alt_outlined,
                              color: AppColor.secondary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _image?.name ?? "Choose an image…",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: _image == null
                                      ? Colors.grey
                                      : AppColor.secondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<RewardsCubit, RewardsState>(
                    builder: (context, state) {
                      final busy = state is RewardActionLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.secondary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: busy ? null : () => _onAdd(context),
                          child: busy
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5))
                              : const Text("Add Reward",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Align(
        alignment: Alignment.centerLeft,
        child: Text(t,
            style: const TextStyle(
                fontSize: 18,
                color: AppColor.secondary,
                fontWeight: FontWeight.w600)),
      );

  Widget _field(TextEditingController c,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: c,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColor.secondary),
        ),
      ),
    );
  }
}
