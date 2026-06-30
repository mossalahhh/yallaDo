import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';

Widget customField({
  TextEditingController? controller,
  String? hint,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AbsorbPointer(
      absorbing: readOnly,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide:
            const BorderSide(color: AppColor.secondary, width: 1.5),
          ),
        ),
      ),
    ),
  );
}

class ChildAvatarItem extends StatelessWidget {
  final int index;
  final int? selectedIndex;
  final String label;
  final String? imagePath;
  final bool isAdd;
  final VoidCallback onTap;

  const ChildAvatarItem({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.label,
    required this.onTap,
    this.imagePath,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor:
            isSelected ? AppColor.secondary : Colors.grey.shade200,
            child: isAdd
                ? Icon(Icons.add,
                color: isSelected ? Colors.white : AppColor.secondary,
                size: 26)
                : imagePath != null
                ? ClipOval(
              child: Image.asset(
                imagePath!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            )
                : null,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight:
              isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColor.secondary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem2 extends StatelessWidget {
  final int index;
  final int? selectedIndex;
  final Map<String, dynamic> category;
  final VoidCallback onTap;

  const CategoryItem2({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: isSelected
                  ? AppColor.secondary.withOpacity(0.2)
                  : const Color(0xFFFDF5E0),
              child: category["imagePath"] != null
                  ? ClipOval(
                child: Image.asset(
                  category["imagePath"] as String,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(
                Icons.category,
                color: isSelected ? AppColor.secondary : Colors.grey,
                size: 28,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category["title"],
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColor.secondary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColor.secondary,
      ),
    );
  }
}

class PhotoSection extends StatelessWidget {
  final bool photoChecked;
  final TextEditingController photoCountController;
  final ValueChanged<bool?> onChanged;

  const PhotoSection({
    super.key,
    required this.photoChecked,
    required this.photoCountController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel("Photo"),
        const SizedBox(height: 8),
        Row(
          children: [
            Checkbox(
              value: photoChecked,
              activeColor: AppColor.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: onChanged,
            ),
            if (photoChecked)
              Expanded(
                child: customField(
                  controller: photoCountController,
                  hint: "Count..",
                ),
              ),
          ],
        ),
      ],
    );
  }
}