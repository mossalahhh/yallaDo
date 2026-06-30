import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_nav.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/features/auth/cubit/auth_cubit/auth_cubit.dart';
import 'package:yallado/features/auth/cubit/auth_cubit/auth_state.dart';
import 'package:yallado/features/auth/views/login_parent_view.dart';
import 'package:yallado/features/auth/views/new_password_view.dart';
import 'package:yallado/features/auth/views/widgets/custom_button.dart';
import 'package:yallado/features/auth/views/widgets/otpi_nput.dart';

/// Why this OTP screen is being shown:
///  * [activation] – confirm a freshly registered account (calls verify-email).
///  * [reset]      – capture the password-reset code, then hand off to the
///                   new-password screen (the backend verifies the code there).
enum VerifyPurpose { activation, reset }

class VerifyEmail extends StatefulWidget {
  final String email;
  final VerifyPurpose purpose;

  /// When activating a freshly registered account, controls which login screen
  /// to return to (child vs parent).
  final bool isChild;

  const VerifyEmail({
    super.key,
    required this.email,
    this.purpose = VerifyPurpose.activation,
    this.isChild = false,
  });

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  String otpCode = "";

  bool get _isActivation => widget.purpose == VerifyPurpose.activation;

  void _onVerify(BuildContext context) {
    if (otpCode.length != 6) {
      SnackBarPopUp().show(
        context: context,
        message: "Please enter the 6-digit code",
        state: PopUpState.warning,
      );
      return;
    }
    if (_isActivation) {
      context.read<AuthCubit>().verifyEmail(
            email: widget.email,
            activationCode: otpCode,
          );
    } else {
      // Reset flow: the code is validated together with the new password on the
      // next screen, so just carry both forward.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPassword(
            email: widget.email,
            resetCode: otpCode,
          ),
        ),
      );
    }
  }

  void _onResend(BuildContext context) {
    context.read<AuthCubit>().resendCode(
          email: widget.email,
          type: _isActivation
              ? AuthCubit.typeActivation
              : AuthCubit.typeForgetPassword,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is VerifyEmailSuccess) {
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
          } else if (state is ResendCodeSuccess) {
            SnackBarPopUp().show(
              context: context,
              message: state.message,
              state: PopUpState.success,
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
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          color: const Color(0xFF4C2D19),
                          onPressed: () => AppNav.back(
                            context,
                            fallback: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ParentLoginScreen(),
                              ),
                              (route) => false,
                            ),
                          ),
                          icon: const Icon(Icons.arrow_back_ios_new_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    Image.asset("images/pana2.png", height: 260),
                    const SizedBox(height: 20),
                    const Text(
                      "Verify Email",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Please enter the 6-digit code sent to\n${widget.email}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8B7F74),
                      ),
                    ),
                    const SizedBox(height: 25),
                    OtpInput(
                      onCompleted: (code) {
                        setState(() => otpCode = code);
                      },
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: "Verify",
                          isLoading: state is AuthLoading,
                          onPressed: () => _onVerify(context),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Didn't receive a code? ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8B7F74),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _onResend(context),
                          child: const Text(
                            "Resend",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              color: Color(0xFF644B3A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
