import 'package:flutter/material.dart';
import 'package:yallado/features/auth/views/confirmation_view.dart';
import 'package:yallado/features/auth/views/forget_password.dart';
import 'package:yallado/features/auth/views/signup_view.dart';
import 'package:yallado/features/auth/views/widgets/curve.dart';
import 'package:yallado/features/auth/views/widgets/custom_button.dart';
import 'package:yallado/features/auth/views/widgets/custom_textformfield.dart';
import 'package:yallado/features/parents/views/verify_email.dart';

import '../../auth/views/new_password_view.dart';
import '../../auth/views/widgets/otpi_nput.dart';
import 'new_password.dart';
class VerifyNewpasswordChild extends StatefulWidget {
  const VerifyNewpasswordChild({super.key});

  @override
  State<VerifyNewpasswordChild> createState() => _VerifyNewPasswordChildState();
}
class _VerifyNewPasswordChildState extends State<VerifyNewpasswordChild> {
  String otpCode = "";


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
                    "Verify Email",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 40),
                  const Text(
                    "Please enter the 6-digit code to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8B7F74),
                    ),
                  ),
                  const SizedBox(height: 26),

                  OtpInput(
                    onCompleted: (code) {
                      setState(() {
                        otpCode = code;
                      });
                    },
                  ),
                  const SizedBox(height: 30),

                  CustomButton(
                      text: "Verify",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>  NewPasswordChild(),
                          ),
                        );
                      }
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive a code? ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8B7F74),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          // TODO: call resend API
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Code resent")),
                          );
                        },
                        child: const Text(
                          "Resend",
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
    );
  }
}