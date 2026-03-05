import 'package:flutter/material.dart';

import '../../domain/entities/financials_project_entity.dart';

class FinancialsPaymentScheduleItemCard extends StatelessWidget {
  const FinancialsPaymentScheduleItemCard({super.key, required this.item});

  final PaymentScheduleItemEntity item;

  @override
  Widget build(BuildContext context) {
    final statusText = item.isPaid ? 'Paid' : 'Due Now';
    final statusColor = item.isPaid ? const Color(0xFF7D9975) : const Color(0xFFC08A2B);
    final iconColor = item.isPaid ? const Color(0xFF8AA481) : const Color(0xFFC08A2B);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: Border.all(
          color: item.isPaid ? const Color(0xFF7D9975).withValues(alpha: 0.55) : const Color(0xFFC08A2B).withValues(alpha: 0.55),

          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 237, 238, 232),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: iconColor.withValues(alpha: 0.55)),
            ),
            child: Icon(item.isPaid ? Icons.check_rounded : Icons.access_time_rounded, size: 24, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF1D1D1D), fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  item.dateLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF5A5A5A), fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatAed(item.amount),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Color(0xFF1D1D1D), fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  statusText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: statusColor, fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatAed(int amount) {
  final formatted = amount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  return 'AED $formatted';
}
