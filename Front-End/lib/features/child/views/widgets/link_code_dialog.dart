import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/features/child/cubit/link_cubit/link_cubit.dart';

/// Reusable "Enter Family Code" dialog (link a child to a parent).
/// Used from the child Settings AND auto-shown on the child home when the
/// child isn't linked to any family yet.
void showLinkCodeDialog(BuildContext rootContext, {VoidCallback? onLinked}) {
  final codeController = TextEditingController();
  showDialog(
    context: rootContext,
    barrierDismissible: false,
    builder: (_) => BlocProvider(
      create: (_) => LinkCubit(),
      child: BlocConsumer<LinkCubit, LinkState>(
        listener: (context, state) {
          if (state is LinkSuccess) {
            Navigator.pop(context);
            SnackBarPopUp().show(
                context: rootContext,
                message: state.message,
                state: PopUpState.success);
            onLinked?.call();
          } else if (state is LinkError) {
            SnackBarPopUp().show(
                context: context,
                message: state.message,
                state: PopUpState.error);
          }
        },
        builder: (context, state) {
          final busy = state is LinkLoading;
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, right: 12),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("Enter Family Code",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.secondary)),
                      const SizedBox(height: 6),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Please enter the family code to link your account",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: codeController,
                          decoration: InputDecoration(
                            hintText: "Enter code..",
                            hintStyle: TextStyle(
                                color: Colors.grey.shade400, fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFFF9F7F0),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: AppColor.secondary, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final code = codeController.text.trim();
                    if (code.isEmpty) {
                      SnackBarPopUp().show(
                          context: context,
                          message: "Please enter the family code!",
                          state: PopUpState.warning);
                      return;
                    }
                    context.read<LinkCubit>().linkAccount(code);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                      color: AppColor.secondary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: busy
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text("Link",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
