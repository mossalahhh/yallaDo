import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/child/views/widgets/greeting_card.dart';
import 'package:yallado/features/child/views/widgets/home_feature_card.dart';
import 'package:yallado/features/user/cubit/profile_cubit/profile_cubit.dart';

class ChildHomeView extends StatelessWidget {
  const ChildHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Load the profile so the greeting can show the child's name (published to
    // ProfileStore) and stay in sync when it's edited.
    return BlocProvider(
      create: (_) => ProfileCubit()..loadProfile(),
      child: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset('images/TICKY.png', height: 100, width: 100),
                Image.asset('images/logo2.png', height: 100, width: 100),
              ],
            ),
            GreetingCard(),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 20,
              crossAxisSpacing: 30,
              childAspectRatio: 0.95,
              children: const [
                HomeFeatureCard(
                  title: 'My Challenge',
                  image: "images/preview3.png",
                  color: Color(0xffa6c7e2),
                ),
                HomeFeatureCard(
                  title: 'My Chat',
                  image: "images/child.png",
                  color: Color(0xfffde798),
                ),
                HomeFeatureCard(
                  title: 'My Reward',
                  image: "images/preview2.png",
                  color: Color(0xffbeeba7),
                ),
                HomeFeatureCard(
                  title: 'Leader Board',
                  image: "images/leaderboard.png",
                  color: Color(0xffFFAFCC),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}
