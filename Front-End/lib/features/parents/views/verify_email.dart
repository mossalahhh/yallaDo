import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/features/auth/views/widgets/curve.dart';
import 'package:yallado/features/auth/views/widgets/custom_button.dart';
import 'package:yallado/features/user/cubit/account_cubit/account_cubit.dart';
import 'package:yallado/features/user/cubit/account_cubit/account_state.dart';
import '../../auth/views/widgets/otpi_nput.dart';

/// Confirms a pending email change for a parent (PATCH user/confirm-email).
class VerifyEmailEdit extends StatefulWidget {
  const VerifyEmailEdit({super.key});

  @override
  State<VerifyEmailEdit> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmailEdit> {
  String otpCode = "";

  void _onVerify(BuildContext context) {
    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid OTP")),
      );
      return;
    }
    context.read<AccountCubit>().confirmEmail(code: otpCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountCubit(),
      child: BlocListener<AccountCubit, AccountState>(
        listener: (context, state) {
          if (state is EmailConfirmed) {
            SnackBarPopUp().show(
                context: context,
                message: state.message,
                state: PopUpState.success);
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state is AccountError) {
            SnackBarPopUp().show(
                context: context,
                message: state.message,
                state: PopUpState.error);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F7F0),
          body: Stack(
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
                child: Column(
                  children: [
                    const SizedBox(height: 200),
                    const Text(
                      "Verify Email",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Please enter the 6-digit code to continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8B7F74)),
                    ),
                    const SizedBox(height: 26),
                    OtpInput(
                      onCompleted: (code) => setState(() => otpCode = code),
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<AccountCubit, AccountState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: "Verify",
                          isLoading: state is AccountLoading,
                          onPressed: () => _onVerify(context),
                        );
                      },
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
