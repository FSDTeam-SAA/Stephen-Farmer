import 'package:flutter/material.dart';

import '../../domain/entities/document_project_entity.dart';

class RecentDocumentItemCard extends StatelessWidget {
  const RecentDocumentItemCard({
    super.key,
    required this.item,
  });

  final RecentDocumentEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE0DFDD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBFC3C5)),
      ),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.file_copy_outlined,
              color: Color(0xFFAF8559),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF202020),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '${item.category}   •  ${item.dateLabel}',
                  style: const TextStyle(
                    color: Color(0xFF2E2E2E),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.download_outlined,
            color: Color(0xFF7E6A54),
            size: 24,
          ),
        ],
      ),
    );
  }
}
