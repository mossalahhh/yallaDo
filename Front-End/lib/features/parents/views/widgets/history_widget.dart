import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';

class HistoryChildAvatar extends StatelessWidget {
  final int index;
  final int? selectedIndex;
  final String name;
  final String image;
  final VoidCallback onTap;

  const HistoryChildAvatar({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.name,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColor.secondary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFFDF5E0),
                backgroundImage: image.startsWith('http')
                    ? NetworkImage(image)
                    : AssetImage(image) as ImageProvider,
                onBackgroundImageError: (_, __) {},
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColor.secondary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String childName;
  final String points;
  final String type;
  final String source;
  final String reason;
  final VoidCallback? onDelete;

  const HistoryCard({
    super.key,
    required this.childName,
    required this.points,
    required this.type,
    required this.source,
    required this.reason,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAdd = type.toLowerCase() == 'add';
    final bool isManual = source.toLowerCase() == 'manual';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HistoryRow(label: "Child Name", value: childName),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAdd
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isAdd ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  if (onDelete != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onDelete,
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          HistoryRow(label: "Points", value: points),
          const SizedBox(height: 8),
          HistoryRow(label: "Source", value: source),
          if (isManual && reason.isNotEmpty) ...[
            const SizedBox(height: 8),
            HistoryRow(label: "Reason", value: reason),
          ],
        ],
      ),
    );
  }
}

class HistoryRow extends StatelessWidget {
  final String label;
  final String value;

  const HistoryRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$label:  ",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColor.secondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}