import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../data/models/child_model.dart';

/// Shows the adjust-points dialog. [onConfirm] receives the API-ready values:
/// `type` is `add`/`remove`, plus the points and reason.
/// [allowance] (from child details) shows the daily budget hint + reset timer.
void showAdjustPointsDialog(
  BuildContext context, {
  required void Function(String type, int points, String reason) onConfirm,
  AdjustAllowance? allowance,
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
                  if (allowance != null && allowance.dailyLimit > 0) ...[
                    _AllowanceHint(allowance: allowance),
                    const SizedBox(height: 16),
                  ],
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
                    // Daily-budget check before hitting the server.
                    if (allowance != null &&
                        allowance.dailyLimit > 0 &&
                        points > allowance.remainingToday) {
                      final left = allowance.remainingToday;
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(
                          content: Text(left > 0
                              ? "You can only adjust $left more point${left == 1 ? '' : 's'} today (limit ${allowance.dailyLimit}/day)"
                              : "Daily limit of ${allowance.dailyLimit} points reached — resets at midnight"),
                        ),
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

/// Daily-budget banner: limit, points left today, and a live countdown to the
/// midnight reset once part of the budget is used.
class _AllowanceHint extends StatefulWidget {
  final AdjustAllowance allowance;

  const _AllowanceHint({required this.allowance});

  @override
  State<_AllowanceHint> createState() => _AllowanceHintState();
}

class _AllowanceHintState extends State<_AllowanceHint> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Refresh the countdown once a minute.
    _timer = Timer.periodic(
        const Duration(minutes: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _untilReset {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final d = midnight.difference(now);
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return "${h}h ${m}m";
    return m > 0 ? "${m}m" : "less than a minute";
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.allowance;
    final exhausted = a.remainingToday <= 0;
    final color = exhausted ? Colors.red.shade700 : AppColor.secondary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Daily limit: ${a.dailyLimit} points (add + remove)",
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            exhausted
                ? "Limit reached — you can't adjust more points today"
                : "You can still adjust ${a.remainingToday} point${a.remainingToday == 1 ? '' : 's'} today",
            style: TextStyle(color: color, fontSize: 13),
          ),
          if (a.usedToday > 0) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.schedule, size: 15, color: color),
                const SizedBox(width: 4),
                Text(
                  "Resets in $_untilReset",
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
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
