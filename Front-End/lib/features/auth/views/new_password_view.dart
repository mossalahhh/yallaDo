import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/helper/app_validator.dart';
import 'package:yallado/features/auth/cubit/auth_cubit/auth_cubit.dart';
import 'package:yallado/features/auth/cubit/auth_cubit/auth_state.dart';
import 'package:yallado/features/auth/views/login_parent_view.dart';
import 'package:yallado/features/auth/views/widgets/custom_button.dart';
import 'package:yallado/features/auth/views/widgets/custom_textformfield.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String resetCode;

  const ResetPassword({
    super.key,
    required this.email,
    required this.resetCode,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().resetPassword(
            email: widget.email,
            resetCode: widget.resetCode,
            newPassword: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            SnackBarPopUp().show(
              context: context,
              message: state.message,
              state: PopUpState.success,
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ParentLoginScreen()),
              (route) => false,
            );
          } else if (state is AuthError) {
            SnackBarPopUp().show(
              context: context,
              message: state.message,
              state: PopUpState.error,
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F7F0),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          color: const Color(0xFF4C2D19),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Image.asset("images/pana3.png", height: 269),
                    const SizedBox(height: 20),
                    const Text(
                      "Enter New Password",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Enter Your New Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8B7F74),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hint: "Enter Your Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: _passwordController,
                      validator: AppValidation.validatePassword,
                    ),
                    CustomTextField(
                      hint: "Confirm Your Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: _confirmController,
                      validator: (v) => AppValidation.validateConfirmPassword(
                          v, _passwordController.text),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: "Save",
                          isLoading: state is AuthLoading,
                          onPressed: () => _onSave(context),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
