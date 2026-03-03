import 'package:flutter/material.dart';

class TaskActionAttentionCard extends StatelessWidget {
  const TaskActionAttentionCard({
    super.key,
    required this.count,
    required this.message,
  });

  final int count;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFD5D2CA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF77716A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC08A2B), width: 2),
            ),
            child: const Icon(
              Icons.priority_high_rounded,
              color: Color(0xFFC08A2B),
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count actions needed',
                  style: const TextStyle(
                    color: Color(0xFF1F1F1F),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF2F2F2F),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
