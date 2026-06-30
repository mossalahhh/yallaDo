import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/features/parents/cubit/invite_code_cubit/invite_code_cubit.dart';
import 'package:yallado/features/parents/cubit/invite_code_cubit/invite_code_state.dart';
import '../../../core/utils/app_colors.dart';

/// Generates and displays the parent's family invite code
/// (`POST parent/invite-code`).
void showFamilyCodeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => BlocProvider(
      create: (_) => InviteCodeCubit()..generate(),
      child: const _FamilyCodeSheet(),
    ),
  );
}

class _FamilyCodeSheet extends StatelessWidget {
  const _FamilyCodeSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F7F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: BlocConsumer<InviteCodeCubit, InviteCodeState>(
        listener: (context, state) {
          if (state is InviteCodeError) {
            SnackBarPopUp().show(
                context: context,
                message: state.message,
                state: PopUpState.error);
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text("Family code",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.secondary)),
              ),
              const SizedBox(height: 24),
              if (state is InviteCodeLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                      child:
                          CircularProgressIndicator(color: AppColor.secondary)),
                )
              else if (state is InviteCodeLoaded) ...[
                _Field(label: "Your code:", value: state.invite.code),
                const SizedBox(height: 16),
                _Field(label: "Max use:", value: "${state.invite.maxUses} Times"),
                const SizedBox(height: 16),
                _Field(
                    label: "Used:",
                    value:
                        "${state.invite.usedCount} / ${state.invite.maxUses}"),
                const SizedBox(height: 16),
                _Field(
                    label: "Expire date:",
                    value: state.invite.expiresAt.contains('T')
                        ? state.invite.expiresAt.split('T').first
                        : state.invite.expiresAt),
              ] else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                      child: Text("Could not load code",
                          style: TextStyle(color: Colors.grey))),
                ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColor.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: state is InviteCodeLoading
                          ? null
                          : () => context.read<InviteCodeCubit>().generate(),
                      child: const Text("Regenerate",
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColor.secondary,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: state is InviteCodeLoaded
                          ? () {
                              Clipboard.setData(
                                  ClipboardData(text: state.invite.code));
                              Navigator.pop(context);
                              SnackBarPopUp().show(
                                  context: context,
                                  message: "Code copied.",
                                  state: PopUpState.success);
                            }
                          : null,
                      child: const Text("Copy",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  const _Field({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.secondary)),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(fontSize: 15, color: AppColor.secondary)),
      ],
    );
  }
}
