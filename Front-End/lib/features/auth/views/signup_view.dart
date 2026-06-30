import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/helper/app_validator.dart';
import 'package:yallado/features/auth/cubit/auth_cubit/auth_cubit.dart';
import 'package:yallado/features/auth/cubit/auth_cubit/auth_state.dart';
import 'package:yallado/features/auth/views/login_parent_view.dart';
import 'package:yallado/features/auth/views/verify_email_view.dart';
import 'package:yallado/features/auth/views/widgets/curve.dart';
import 'package:yallado/features/auth/views/widgets/custom_button.dart';
import 'package:yallado/features/auth/views/widgets/custom_textformfield.dart';

class SignupScreen extends StatefulWidget {
  /// Optional initial role; the user can still switch it in the form.
  final String role;
  const SignupScreen({super.key, this.role = 'parent'});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _dobController = TextEditingController();

  /// The account role is chosen here (not at login). 'parent' | 'child'.
  late String _role = widget.role;
  bool get _isChild => _role == 'child';

  String? _gender; // 'male' | 'female'
  DateTime? _dob;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobController.text =
            "${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _onSignup(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_gender == null) {
      SnackBarPopUp().show(
        context: context,
        message: "Please select your gender",
        state: PopUpState.warning,
      );
      return;
    }
    if (_dob == null) {
      SnackBarPopUp().show(
        context: context,
        message: "Please select your date of birth",
        state: PopUpState.warning,
      );
      return;
    }
    context.read<AuthCubit>().register(
          name: _nameController.text.trim(),
          userName: _userNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmController.text,
          gender: _gender!,
          dateOfBirth: _dobController.text,
          role: _role,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            SnackBarPopUp().show(
              context: context,
              message: state.message,
              state: PopUpState.success,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => VerifyEmail(
                  email: state.email,
                  purpose: VerifyPurpose.activation,
                  isChild: _isChild,
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
          body: Stack(
            children: [
              const CurvedHeaderTwo(height: 220),
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
                  child: ListView(
                    children: [
                      const SizedBox(height: 150),
                      const Text(
                        "Get Started",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("I am a",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4C2D19))),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _RolePill(
                              label: "Parent",
                              icon: Icons.family_restroom,
                              selected: _role == 'parent',
                              onTap: () => setState(() => _role = 'parent'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _RolePill(
                              label: "Child",
                              icon: Icons.child_care,
                              selected: _role == 'child',
                              onTap: () => setState(() => _role = 'child'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hint: "Enter Your Full Name",
                        icon: Icons.person_2_outlined,
                        controller: _nameController,
                        validator: AppValidation.validateRequired,
                      ),
                      CustomTextField(
                        hint: "Enter Your Email",
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidation.validateEmail,
                      ),
                      CustomTextField(
                        hint: "User Name",
                        icon: Icons.person_2_outlined,
                        controller: _userNameController,
                        validator: AppValidation.validateRequired,
                      ),
                      CustomTextField(
                        hint: "Date Of Birth",
                        icon: Icons.calendar_today_outlined,
                        controller: _dobController,
                        readOnly: true,
                        onTap: _pickDate,
                        validator: AppValidation.validateRequired,
                      ),
                      const SizedBox(height: 8),
                      _GenderSelector(
                        selected: _gender,
                        onChanged: (g) => setState(() => _gender = g),
                      ),
                      const SizedBox(height: 8),
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
                            text: "Sign Up",
                            isLoading: state is AuthLoading,
                            onPressed: () => _onSignup(context),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF8B7F74),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ParentLoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 17,
                                color: Color(0xFF644B3A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Minimal gender picker added so the existing signup form can satisfy the
/// `gender` field required by `auth/register`.
class _GenderSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onChanged;

  const _GenderSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _option("male", Icons.male)),
        const SizedBox(width: 12),
        Expanded(child: _option("female", Icons.female)),
      ],
    );
  }

  Widget _option(String value, IconData icon) {
    final bool active = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFD8E4CC) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: active ? const Color(0xFF4C2D19) : const Color(0xFF8B7F74),
            width: active ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF4C2D19)),
            const SizedBox(width: 8),
            Text(
              value[0].toUpperCase() + value.substring(1),
              style: const TextStyle(
                color: Color(0xFF4C2D19),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Parent/Child role picker for the signup form (role is chosen here, not at
/// login).
class _RolePill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RolePill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD8E4CC) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: selected ? const Color(0xFF4C2D19) : const Color(0xFF8B7F74),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF4C2D19)),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF4C2D19),
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
