import 'package:flutter/material.dart';
import 'package:yallado/features/parents/views/widgets/parent_bottom_navigation.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed( Duration(seconds: 4), () {
      Navigator.pushReplacement(context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (_, _, _) => ParentBottomNavigationBar(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xfff6f0ee),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffd0e1c3),
              Color(0xffffffff),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 180,),
              Image.asset("images/logo2.png"),
              // Image.asset("images/TICKY.png"),
            ],
          ),
        ),
      ),
    );
  }
}
