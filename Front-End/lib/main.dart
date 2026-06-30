import 'package:flutter/material.dart';
import 'features/splash/views/start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor:Color(0xff9372cb)),
      //   scaffoldBackgroundColor: Colors.transparent,
      //   useMaterial3: true,
      // ),
      home:Start(),
      // builder: (context, child) {
      //   return GradientBackground(child: child!);
      // },
    );
  }
}


class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff9372cb), Color(0xffffffff)],
          begin: Alignment.bottomCenter,
          end: Alignment.center,
        ),
      ),
      child: child,
    );
  }
}
