import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/helper/app_validator.dart';
import 'package:yallado/features/auth/cubit/auth_cubit/auth_cubit.dart';
import 'package:yallado/features/auth/cubit/auth_cubit/auth_state.dart';
import 'package:yallado/features/auth/views/verify_email_view.dart';
import 'package:yallado/features/auth/views/widgets/custom_button.dart';
import 'package:yallado/features/auth/views/widgets/custom_textformfield.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSend(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context
          .read<AuthCubit>()
          .forgetPassword(email: _emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) {
            SnackBarPopUp().show(
              context: context,
              message: state.message,
              state: PopUpState.success,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VerifyEmail(
                  email: state.email,
                  purpose: VerifyPurpose.reset,
                ),
              ),
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
                    const SizedBox(height: 30),
                    Image.asset("images/pana.png", height: 269),
                    const SizedBox(height: 20),
                    const Text(
                      "Forget Password",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Please Enter Your Email Address To\nReceive a Verification Code",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8B7F74),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hint: "Your Email",
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidation.validateEmail,
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: "Send",
                          isLoading: state is AuthLoading,
                          onPressed: () => _onSend(context),
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
