import 'package:flutter/material.dart';
import 'package:yallado/features/auth/views/signup_view.dart';

class OnboardPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final bool showButtons;

  const OnboardPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.showButtons = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 270, width: 400),
          SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Color(0xFF261C15),
            ),
          ),
          SizedBox(height: 15),
          if (description.isNotEmpty)
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, color: Color(0xFF8B7F74),fontWeight: FontWeight.w400),
            ),
          if (showButtons) ...[
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C2D19),
                elevation: 8,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text("Get Started", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }
}
