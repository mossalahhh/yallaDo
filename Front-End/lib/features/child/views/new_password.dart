import 'package:flutter/material.dart';
import 'package:yallado/features/auth/views/confirmation_view.dart';
import 'package:yallado/features/auth/views/forget_password.dart';
import 'package:yallado/features/auth/views/signup_view.dart';
import 'package:yallado/features/auth/views/widgets/curve.dart';
import 'package:yallado/features/auth/views/widgets/custom_button.dart';
import 'package:yallado/features/auth/views/widgets/custom_textformfield.dart';
import 'package:yallado/features/parents/views/verify_email.dart';

import '../../../core/utils/app_colors.dart';
import 'Verfiyemail_child.dart';

class NewPasswordChild extends StatelessWidget {
  const NewPasswordChild({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F7F0),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CurvedHeader(height: 220),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: 10,
              ),
              child: IconButton(
                color: Color(0xFF4C2D19),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_outlined),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 200),
                  Text(
                    "Enter New Password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColor.secondary,
                    ),
                  ),

                  SizedBox(height: 40),

                  Form(
                    child: Column(
                      children: [
                        CustomTextField(
                          hint: "Enter Your  Password",
                          icon: Icons.lock_outline,
                        ),
                        CustomTextField(
                          hint: "Confirm Your Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),
                  CustomButton(
                    text: "Save",
                    onPressed: () {

                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}