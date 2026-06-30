import 'package:flutter/material.dart';
import 'package:yallado/features/parents/views/family_code_dialog.dart';
import 'package:yallado/features/parents/views/profile.dart';
import 'package:yallado/features/parents/views/setting.dart';
class SideMenuPopup extends StatelessWidget {
  const SideMenuPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _menuItem(
                title: 'Profile',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
                },
              ),

              _menuItem(
                title: 'Setting',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(),));
                },
              ),

              _menuItem(
                title: 'Family Code',
                onTap: () {
                  Navigator.pop(context);
                  showFamilyCodeBottomSheet(context);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}