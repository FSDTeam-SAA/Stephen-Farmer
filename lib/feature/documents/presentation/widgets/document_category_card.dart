import 'package:flutter/material.dart';

import '../../domain/entities/document_project_entity.dart';

class DocumentCategoryCard extends StatelessWidget {
  const DocumentCategoryCard({super.key, required this.item});

  final DocumentCategoryEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFD4D1C8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E4DE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _resolveIcon(item.type),
              color: _resolveIconColor(item.type),
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF1D1D1D),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const Spacer(),
          Text(
            '${item.fileCount} files',
            style: const TextStyle(
              color: Color(0xFF2E2E2E),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _resolveIcon(String type) {
  switch (type.trim().toLowerCase()) {
    case 'drawings':
      return Icons.edit_note_rounded;
    case 'invoices':
      return Icons.map_outlined;
    case 'reports':
      return Icons.assignment_outlined;
    case 'contracts':
      return Icons.file_copy_outlined;
    default:
      return Icons.insert_drive_file_outlined;
  }
}

Color _resolveIconColor(String type) {
  switch (type.trim().toLowerCase()) {
    case 'drawings':
      return const Color(0xFFA17E32);
    case 'invoices':
      return const Color(0xFF6B8B49);
    case 'reports':
      return const Color(0xFF9B7650);
    case 'contracts':
      return const Color(0xFF1F1F1F);
    default:
      return const Color(0xFF6A6A6A);
  }
}
