import 'package:flutter/material.dart';
import 'package:yallado/features/child/views/child_home_view.dart';

class ChildLayoutView extends StatefulWidget {
  const ChildLayoutView({super.key});

  @override
  State<ChildLayoutView> createState() => _ChildLayoutViewState();
}

class _ChildLayoutViewState extends State<ChildLayoutView> {
  int currentIndex = 0;

  final List<Widget> screens =  [
     ChildHomeView(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
    // ChildProfileView(),
    // ChildSettingsView(),
    // ChildNotificationsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor:  Color(0xff6C63FF),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items:  [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}


