import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/helper/app_validator.dart';
import 'package:yallado/features/auth/views/widgets/curve.dart';
import 'package:yallado/features/auth/views/widgets/custom_button.dart';
import 'package:yallado/features/auth/views/widgets/custom_textformfield.dart';
import 'package:yallado/features/child/views/Verfiyemail_child.dart';
import 'package:yallado/features/child/views/forget_password.dart';
import 'package:yallado/features/user/cubit/account_cubit/account_cubit.dart';
import 'package:yallado/features/user/cubit/account_cubit/account_state.dart';

class ChangeEmailChild extends StatefulWidget {
  const ChangeEmailChild({super.key});

  @override
  State<ChangeEmailChild> createState() => _ChangeEmailChildState();
}

class _ChangeEmailChildState extends State<ChangeEmailChild> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AccountCubit>().changeEmail(
            newEmail: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountCubit(),
      child: BlocListener<AccountCubit, AccountState>(
        listener: (context, state) {
          if (state is EmailChangeSent) {
            SnackBarPopUp().show(
                context: context,
                message: state.message,
                state: PopUpState.success);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VerifyEmailChild()),
            );
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
                          "Change Email",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          hint: "Enter Your New Email",
                          icon: Icons.email_outlined,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: AppValidation.validateEmail,
                        ),
                        CustomTextField(
                          hint: "Enter Your Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: _passwordController,
                          validator: AppValidation.validatePassword,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ForgetPasswordChild()),
                            ),
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF644B3A)),
                            ),
                          ),
                        ),
                        BlocBuilder<AccountCubit, AccountState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: "OK",
                              isLoading: state is AccountLoading,
                              onPressed: () => _onSubmit(context),
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
