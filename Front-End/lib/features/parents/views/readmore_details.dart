import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/features/parents/cubit/child_details_cubit/child_details_cubit.dart';
import 'package:yallado/features/parents/cubit/child_details_cubit/child_details_state.dart';
import 'package:yallado/features/parents/views/widgets/adjust_point_dialog.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_network_image.dart';

class MoreDetailsScreen extends StatelessWidget {
  final String childId;
  final String name;
  final String avatarUrl;

  const MoreDetailsScreen({
    super.key,
    required this.childId,
    required this.name,
    this.avatarUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChildDetailsCubit(childId)..loadDetails(),
      child: _MoreDetailsBody(name: name, avatarUrl: avatarUrl),
    );
  }
}

class _MoreDetailsBody extends StatelessWidget {
  final String name;
  final String avatarUrl;
  const _MoreDetailsBody({required this.name, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F0),
      body: SafeArea(
        child: BlocConsumer<ChildDetailsCubit, ChildDetailsState>(
          listener: (context, state) {
            if (state is PointsAdjusted) {
              SnackBarPopUp().show(
                  context: context,
                  message: state.message,
                  state: PopUpState.success);
            } else if (state is PointsAdjustError || state is ChildDetailsError) {
              final msg = state is PointsAdjustError
                  ? state.message
                  : (state as ChildDetailsError).message;
              SnackBarPopUp().show(
                  context: context, message: msg, state: PopUpState.error);
            }
          },
          builder: (context, state) {
            final cubit = context.read<ChildDetailsCubit>();
            final details = cubit.details;
            if (details == null) {
              return Center(
                child: state is ChildDetailsError
                    ? Text(state.message,
                        style: const TextStyle(color: AppColor.secondary))
                    : const CircularProgressIndicator(
                        color: AppColor.secondary),
              );
            }
            final activity = details.latestActivity;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: AppColor.secondary),
                      ),
                      const SizedBox(width: 8),
                      const Text("More Details",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColor.secondary)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        AppAvatar(url: avatarUrl, radius: 50),
                        const SizedBox(height: 10),
                        Text(details.name.isEmpty ? name : details.name,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColor.secondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _DetailItem(label: "Age", value: "${details.age}"),
                  _DetailItem(
                      label: "Total Points", value: "${details.totalPoints}"),
                  _DetailItem(
                      label: "Spent Points", value: "${details.spentPoints}"),
                  _DetailItem(
                      label: "Total Tasks",
                      value: "${details.taskStats.total}"),
                  _DetailItem(
                      label: "Approved",
                      value: "${details.taskStats.approved}"),
                  _DetailItem(
                      label: "Rejected",
                      value: "${details.taskStats.rejected}"),
                  _DetailItem(
                      label: "Pending", value: "${details.taskStats.pending}"),
                  const SizedBox(height: 10),
                  const Text("Last Activity",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColor.secondary)),
                  if (activity == null)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("No activity yet",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    )
                  else ...[
                    _DetailItem(label: "Type", value: activity.type),
                    _DetailItem(
                        label: "Point of Last Activity",
                        value: "${activity.points}"),
                    _DetailItem(label: "Source", value: activity.source),
                  ],
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => showAdjustPointsDialog(
                        context,
                        allowance: cubit.details?.adjustAllowance,
                        onConfirm: (type, points, reason) {
                          cubit.adjustPoints(
                              type: type, points: points, reason: reason);
                        },
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("Adjust Points",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text("$label:  ",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.secondary)),
          Text(value,
              style: const TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}
