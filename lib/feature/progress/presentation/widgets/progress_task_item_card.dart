import 'package:flutter/material.dart';

import '../../domain/entities/progress_entity.dart';

class ProgressTaskItemCard extends StatelessWidget {
  const ProgressTaskItemCard({super.key, required this.task});

  final ProgressTaskEntity task;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = task.status.toLowerCase() == 'completed';
    final Color statusColor = isCompleted ? const Color(0xFF34C759) : const Color(0xFFAAB5BA);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111A1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB9A77D)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(color: const Color(0xFFE3D2AA), borderRadius: BorderRadius.circular(10)),
                  child: Icon(isCompleted ? Icons.check_rounded : Icons.access_time_rounded, size: 18, color: const Color(0xFF141414)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        task.status,
                        style: TextStyle(color: statusColor, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${task.progressPercent}%',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 9),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: task.progressPercent.clamp(0, 100) / 100,
                minHeight: 8,
                backgroundColor: Colors.white,
                color: const Color(0xFFE3D2AA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
