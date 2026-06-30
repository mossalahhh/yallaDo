import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/helper/app_validator.dart';
import 'package:yallado/features/auth/cubit/auth_cubit/auth_cubit.dart';
import 'package:yallado/features/auth/cubit/auth_cubit/auth_state.dart';
import 'package:yallado/features/auth/views/forget_password.dart';
import 'package:yallado/features/auth/views/signup_view.dart';
import 'package:yallado/features/auth/views/widgets/curve.dart';
import 'package:yallado/features/auth/views/widgets/custom_button.dart';
import 'package:yallado/features/auth/views/widgets/custom_textformfield.dart';
import 'package:yallado/features/child/views/widgets/child_bottom_navigation.dart';
import 'package:yallado/features/parents/views/widgets/parent_bottom_navigation.dart';

/// Child login — mirrors the parent login (email + password). Children
/// authenticate exactly like parents; the family-code link step happens after
/// login from the child Settings screen.
class LoginChildScreen extends StatefulWidget {
  const LoginChildScreen({super.key});

  @override
  State<LoginChildScreen> createState() => _LoginChildScreenState();
}

class _LoginChildScreenState extends State<LoginChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  void _routeByRole(BuildContext context, String role) {
    final Widget home = role == 'parent'
        ? const ParentBottomNavigationBar()
        : const ChildBottomNavigationBar();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => home),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            _routeByRole(context, state.token.role);
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
                  child: Column(
                    children: [
                      const SizedBox(height: 200),
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              hint: "Enter Your Email",
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
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgetPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xFF644B3A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: "Login",
                            isLoading: state is AuthLoading,
                            onPressed: () => _onLogin(context),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF8B7F74),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SignupScreen(role: 'child'),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign up",
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
      ),
    );
  }
}
