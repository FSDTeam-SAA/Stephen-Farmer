import 'package:flutter/material.dart';

class TaskSectionHeaderRow extends StatelessWidget {
  const TaskSectionHeaderRow({
    super.key,
    required this.title,
    required this.pendingCount,
    required this.isInterior,
    this.showLeadingIcon = false,
  });

  final String title;
  final int pendingCount;
  final bool isInterior;
  final bool showLeadingIcon;

  @override
  Widget build(BuildContext context) {
    final titleColor = isInterior ? const Color(0xFF1D1D1D) : Colors.white;
    final badgeColor = isInterior
        ? const Color(0xFF7C715E)
        : const Color(0xFF1B262D);

    return Row(
      children: [
        if (showLeadingIcon)
          Icon(Icons.person_outline_rounded, color: titleColor, size: 18),
        if (showLeadingIcon) const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: titleColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$pendingCount PENDING',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
