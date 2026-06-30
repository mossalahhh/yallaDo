import 'package:flutter/material.dart';
class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key, this.onPressed, required this.text});
  final void Function()? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4C2D19),
        foregroundColor: Colors.white,
        minimumSize:  Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child:  Text(text,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
    );
  }
}
