import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({super.key,
    required this.controller, required this.prefix,
    this.suffix,
    required this.hintText,
    this.validator,
    this.obscureText = false
  });
  final TextEditingController controller;
  final Widget prefix;
  final Widget? suffix;
  final Widget hintText;
  final String? Function(String?)? validator;
  final bool obscureText;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
          prefixIcon: prefix,
          suffixIcon: suffix,
          hint: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: AppColor.primary,
                  width: 2
              )
          ),
          fillColor: Color(0xfff1f1f2),
          filled: true
      ),
    );
  }
}