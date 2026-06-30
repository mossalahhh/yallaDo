import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:yallado/core/network/app_prefs.dart';
import 'package:yallado/features/splash/views/widgets/custom_onboard.dart';

class OnboardingScreen extends StatefulWidget {
  /// When true, skip the two intro pages and open directly on the role-selection
  /// page (used on every launch after the first).
  final bool startAtRolePage;
  const OnboardingScreen({super.key, this.startAtRolePage = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller =
      PageController(initialPage: widget.startAtRolePage ? 2 : 0);
  late bool isLastPage = widget.startAtRolePage;

  @override
  void initState() {
    super.initState();
    // Mark the intro as seen so it isn't shown again on future launches.
    AppPrefs.setSeenOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() => isLastPage = index == 2);
                  },
                  children: [
                    OnboardPage(
                      image: "images/preview1.png",
                      title: "Make every task a fun\nadventure with YallaDo! 🎉",
                      description:
                          "\"Together, make every task a fun step to\nlearn, grow, and shine!\" ✨",
                    ),
                    OnboardPage(
                      image: "images/preview2.png",
                      title: "YallaDo makes progress fun\nand rewarding! 🏆",
                      description:
                          "Kids earn stars ✨, unlock rewards 🎁, and build happy habits together!",
                    ),
                    OnboardPage(
                      image: "images/preview3.png",
                      title: "Choose your role to start\nyour adventure! 🌈",
                      description: "",
                      showButtons: true,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: isLastPage
                        ? SizedBox.shrink()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4C2618),
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(10),
                            ),
                            onPressed: () {
                              _controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                  ),
                ],
              ),
              SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: WormEffect(
                  dotColor: Color(0xff8b7f74),
                  activeDotColor: Color(0xff4c2618),
                  dotHeight: 18,
                  dotWidth: 18,
                  spacing: 15,
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
