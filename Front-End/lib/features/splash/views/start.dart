import 'package:flutter/material.dart';
import 'package:yallado/core/helper/jwt_helper.dart';
import 'package:yallado/core/network/app_prefs.dart';
import 'package:yallado/core/network/token_storage.dart';
import 'package:yallado/features/child/views/widgets/child_bottom_navigation.dart';
import 'package:yallado/features/parents/views/widgets/parent_bottom_navigation.dart';
import 'package:yallado/features/splash/views/onboarding.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _decideNext);
  }

  Future<void> _decideNext() async {
    if (!mounted) return;
    final token = await TokenStorage.getToken();

    // 1) Already logged in → straight to the role's home (auto-login).
    if (token != null && token.isNotEmpty) {
      final role = JwtHelper.roleFromToken(token);
      final Widget home = role == 'parent'
          ? const ParentBottomNavigationBar()
          : const ChildBottomNavigationBar();
      _go(home);
      return;
    }

    // 2) Not logged in → show the intro only the first time; afterwards jump
    //    straight to the role-selection page.
    final seen = await AppPrefs.seenOnboarding();
    _go(OnboardingScreen(startAtRolePage: seen));
  }

  void _go(Widget page) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f0ee),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffd0e1c3), Color(0xffffffff)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 180),
              Image.asset("images/logo2.png"),
            ],
          ),
        ),
      ),
    );
  }
}
