import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

Widget customField({TextEditingController? controller, String? hint, bool readOnly = false, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: AbsorbPointer(
      absorbing: readOnly,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.secondary, width: 1.5),
          ),
        ),
      ),
    ),
  );
}