import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

/// Shows the adjust-points dialog. [onConfirm] receives the API-ready values:
/// `type` is `add`/`remove`, plus the points and reason.
void showAdjustPointsDialog(
  BuildContext context, {
  required void Function(String type, int points, String reason) onConfirm,
}) {
  String selectedType = 'add';
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: const Color(0xFFF9F7F0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Adjust Points",
                style: TextStyle(
                  color: AppColor.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Type",
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _TypeButton(
                          label: "Add",
                          isSelected: selectedType == 'add',
                          onTap: () => setState(() => selectedType = 'add'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TypeButton(
                          label: "Remove",
                          isSelected: selectedType == 'remove',
                          onTap: () => setState(() => selectedType = 'remove'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Points",
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _DialogTextField(
                    controller: pointsController,
                    hintText: "Enter number of points...",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Reason",
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _DialogTextField(
                    controller: reasonController,
                    hintText: "Enter reason...",
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final int points = int.tryParse(pointsController.text) ?? 0;
                    final String reason = reasonController.text.trim();
                    if (points <= 0) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text("Enter a valid points value")),
                      );
                      return;
                    }
                    Navigator.pop(dialogContext);
                    onConfirm(selectedType, points, reason);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.secondary),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColor.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _DialogTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType keyboardType;

  const _DialogTextField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.secondary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.secondary.withValues(alpha: 0.4)),
        ),
      ),
    );
  }
}
