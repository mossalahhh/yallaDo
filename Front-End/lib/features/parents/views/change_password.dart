import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/helper/app_validator.dart';
import 'package:yallado/features/auth/views/widgets/curve.dart';
import 'package:yallado/features/auth/views/widgets/custom_button.dart';
import 'package:yallado/features/auth/views/widgets/custom_textformfield.dart';
import 'package:yallado/features/user/cubit/account_cubit/account_cubit.dart';
import 'package:yallado/features/user/cubit/account_cubit/account_state.dart';

class ChangePasswordEdit extends StatefulWidget {
  const ChangePasswordEdit({super.key});

  @override
  State<ChangePasswordEdit> createState() => _ChangePasswordEditState();
}

class _ChangePasswordEditState extends State<ChangePasswordEdit> {
  final _formKey = GlobalKey<FormState>();
  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AccountCubit>().updatePassword(
            oldPassword: _oldController.text,
            newPassword: _newController.text,
            confirmPassword: _confirmController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountCubit(),
      child: BlocListener<AccountCubit, AccountState>(
        listener: (context, state) {
          if (state is PasswordUpdated) {
            SnackBarPopUp().show(
                context: context,
                message: state.message,
                state: PopUpState.success);
            Navigator.pop(context);
          } else if (state is AccountError) {
            SnackBarPopUp().show(
                context: context,
                message: state.message,
                state: PopUpState.error);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F7F0),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                const CurvedHeader(height: 220),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10),
                  child: IconButton(
                    color: const Color(0xFF4C2D19),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 200),
                        const Text(
                          "Enter New Password",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Enter Your New Password",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8B7F74)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          hint: "Enter Your Current Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: _oldController,
                          validator: AppValidation.validatePassword,
                        ),
                        CustomTextField(
                          hint: "Enter Your New Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: _newController,
                          validator: AppValidation.validatePassword,
                        ),
                        CustomTextField(
                          hint: "Confirm Your New Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: _confirmController,
                          validator: (v) =>
                              AppValidation.validateConfirmPassword(
                                  v, _newController.text),
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<AccountCubit, AccountState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: "Save",
                              isLoading: state is AccountLoading,
                              onPressed: () => _onSave(context),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
