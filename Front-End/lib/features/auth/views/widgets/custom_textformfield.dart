import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        obscureText: widget.isPassword && _obscure,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(
              color: Color(0xFF8B7F74),
              fontSize: 16,
              fontWeight: FontWeight.w600),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF8B7F74),
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                )
              : Icon(widget.icon, color: const Color(0xFF8B7F74)),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Color(0xFF8B7F74), width: 3),
          ),
        ),
      ),
    );
  }
}
