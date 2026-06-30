import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/core/widgets/app_network_image.dart';
import 'package:yallado/features/parents/cubit/children_cubit/children_cubit.dart';
import 'package:yallado/features/parents/cubit/children_cubit/children_state.dart';

void showUnlinkSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => ChildrenCubit()..loadChildren(),
      child: const _UnlinkSheet(),
    ),
  );
}

class _UnlinkSheet extends StatefulWidget {
  const _UnlinkSheet();

  @override
  State<_UnlinkSheet> createState() => _UnlinkSheetState();
}

class _UnlinkSheetState extends State<_UnlinkSheet> {
  String? selectedChildId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F7F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: BlocConsumer<ChildrenCubit, ChildrenState>(
        listener: (context, state) {
          if (state is ChildUnlinked) {
            Navigator.pop(context);
            SnackBarPopUp().show(
                context: context,
                message: state.message,
                state: PopUpState.success);
          } else if (state is ChildActionError) {
            SnackBarPopUp().show(
                context: context,
                message: state.message,
                state: PopUpState.error);
          }
        },
        builder: (context, state) {
          final children = context.read<ChildrenCubit>().children;
          final bool busy = state is ChildActionLoading;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Unlink a Child",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColor.secondary)),
              const SizedBox(height: 6),
              const Text("Select the child you want to unlink",
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 24),
              if (state is ChildrenLoading && children.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                      child:
                          CircularProgressIndicator(color: AppColor.secondary)),
                )
              else if (children.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text("No children linked",
                      style: TextStyle(color: Colors.grey)),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: children.map((child) {
                      final isSelected = selectedChildId == child.childId;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => selectedChildId = child.childId),
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColor.secondary
                                        : Colors.transparent,
                                    width: 2.5,
                                  ),
                                ),
                                child:
                                    AppAvatar(url: child.avatarUrl, radius: 34),
                              ),
                              const SizedBox(height: 8),
                              Text(child.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColor.secondary
                                        : Colors.grey.shade600,
                                  )),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (selectedChildId == null || busy)
                      ? null
                      : () => context
                          .read<ChildrenCubit>()
                          .unlinkChild(selectedChildId!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.secondary,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: busy
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : const Text("Unlink",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
