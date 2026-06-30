import 'package:flutter/material.dart';
import 'package:yallado/core/utils/app_colors.dart';

class TaskCardParent extends StatelessWidget {
  final String title;
  final int points;
  final String status;
  final bool isLast;
  final VoidCallback onTap;

  const TaskCardParent({
    super.key,
    required this.title,
    required this.points,
    required this.status,
    required this.onTap,
    this.isLast = false,
  });

  Color get _statusColor {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'submitted':
        return Colors.orange;
      default:
        return AppColor.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool done = status == 'approved';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: done ? const Color(0xFF9DC178) : Colors.white,
                  border: Border.all(
                    color: done ? Colors.white : AppColor.secondary,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: done
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
            if (!isLast) ...[
              const SizedBox(height: 4),
              Container(
                width: 2,
                height: 60,
                color: AppColor.secondary.withValues(alpha: 0.4),
              ),
            ],
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFD1E2C4),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("images/preview3.png", height: 70, width: 70),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColor.secondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text("$points pts",
                                  style: const TextStyle(
                                      color: AppColor.secondary, fontSize: 13)),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _statusColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status.isEmpty ? 'pending' : status,
                                  style: TextStyle(
                                      color: _statusColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
