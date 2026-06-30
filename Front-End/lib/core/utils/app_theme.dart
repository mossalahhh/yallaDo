import 'package:flutter/material.dart';

class AppTheme {
  // static const LinearGradient backgroundGradient = LinearGradient(
  //   colors: [
  //     Color(0xFFB49BF0),
  //     Color(0xffffffff)
  //   ],
  //   begin: Alignment.bottomCenter,
  //   end: Alignment.topCenter,
  // );

  // static BoxDecoration gradientBackground() {
  //   return const BoxDecoration(gradient: backgroundGradient);
  // }

  static InputDecoration textFieldDecoration(String hint, {IconData? icon,}) {
    return InputDecoration(

      hintText: hint,
      hintStyle: TextStyle(color: Color(0xFF9F9BBD),fontSize: 18,fontWeight: FontWeight.w500),
      suffixIcon: icon != null ? Icon(icon, color: Color(0xFF423A7C),size: 25,) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Color(0xFF423A7C),width: 3,style: BorderStyle.solid)
      ),

    );
  }

  static ButtonStyle purpleButton = ElevatedButton.styleFrom(
    fixedSize: Size(330, 55),
    backgroundColor: Color(0xFF8B7FE1),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),),
    padding: const EdgeInsets.symmetric(vertical: 15),
  );
}
