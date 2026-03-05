import 'package:flutter/material.dart';

class TaskSectionHeaderRow extends StatelessWidget {
  const TaskSectionHeaderRow({
    super.key,
    required this.title,
    required this.pendingCount,
    this.showLeadingIcon = false,
  });

  final String title;
  final int pendingCount;
  final bool showLeadingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showLeadingIcon)
          const Icon(
            Icons.person_outline_rounded,
            color: Colors.white,
            size: 18,
          ),
        if (showLeadingIcon) const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
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
              color: const Color(0xFF7C715E),
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
