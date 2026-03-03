import 'package:flutter/material.dart';

import '../../domain/entities/task_project_entity.dart';

class TaskActionItemCard extends StatelessWidget {
  const TaskActionItemCard({
    super.key,
    required this.item,
  });

  final TaskItemEntity item;

  @override
  Widget build(BuildContext context) {
    final bool highPriority = item.priority.trim().toLowerCase() == 'high';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFD5D2CA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF77716A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFFB07E2A), size: 28),
            ],
          ),
          Text(
            item.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF2E2E2E),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: highPriority ? const Color(0xFFF08383) : const Color(0xFF8A6400),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              item.priority,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
