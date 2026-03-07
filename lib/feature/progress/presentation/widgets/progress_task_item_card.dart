import 'package:flutter/material.dart';

import '../../domain/entities/progress_entity.dart';

class ProgressTaskItemCard extends StatelessWidget {
  const ProgressTaskItemCard({
    super.key,
    required this.task,
    this.isInteriorTheme = false,
  });

  final ProgressTaskEntity task;
  final bool isInteriorTheme;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = task.status.toLowerCase() == 'completed';
    final Color statusColor = isCompleted
        ? const Color(0xFF34C759)
        : const Color(0xFFAAB5BA);
    final Color titleColor = isInteriorTheme
        ? const Color(0xFF1D1D1D)
        : Colors.white;
    final Color subtitleColor = isInteriorTheme
        ? const Color(0xFF5C5C5C)
        : const Color(0xFF8A979D);
    final Color percentColor = isInteriorTheme
        ? const Color(0xFF1D1D1D)
        : Colors.white;
    final Color cardColor = isInteriorTheme
        ? Colors.white.withValues(alpha: 0.55)
        : const Color(0xFF111A1E);
    final Color progressBackground = isInteriorTheme
        ? Colors.black.withValues(alpha: 0.12)
        : Colors.white;
    final String? note = task is ProgressUpdateEntity
        ? (task as ProgressUpdateEntity).note.trim().isEmpty
              ? null
              : (task as ProgressUpdateEntity).note.trim()
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3D2AA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isCompleted ? Icons.check_rounded : Icons.access_time_rounded,
                  size: 18,
                  color: const Color(0xFF141414),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      task.status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (note != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        note,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${task.progressPercent}%',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: percentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (task.dateLabel != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      task.dateLabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: task.progressPercent.clamp(0, 100) / 100,
              minHeight: 8,
              backgroundColor: progressBackground,
              color: const Color(0xFFE3D2AA),
            ),
          ),
        ],
      ),
    );
  }
}
