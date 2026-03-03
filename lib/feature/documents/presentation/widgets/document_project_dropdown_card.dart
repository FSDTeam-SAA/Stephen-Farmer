import 'package:flutter/material.dart';
import 'package:stephen_farmer/core/utils/images.dart';

import '../../domain/entities/document_project_entity.dart';

class DocumentProjectDropdownCard extends StatelessWidget {
  const DocumentProjectDropdownCard({
    super.key,
    required this.projects,
    required this.selectedProjectIndex,
    required this.isMenuOpen,
    required this.onToggle,
    required this.onSelect,
  });

  final List<DocumentProjectEntity> projects;
  final int selectedProjectIndex;
  final bool isMenuOpen;
  final VoidCallback onToggle;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) return const SizedBox.shrink();

    final selected = projects[selectedProjectIndex.clamp(0, projects.length - 1)];

    return Container(
      height: 57,
      decoration: BoxDecoration(
        color: const Color(0xFF0E181E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF657279)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onToggle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  child: _ProjectRow(item: selected, showChevron: projects.length > 1, isMenuOpen: isMenuOpen),
                ),
              ),
            ),
            if (isMenuOpen && projects.length > 1) ...[
              Divider(height: 1, thickness: 1, color: const Color(0xFF657279).withValues(alpha: 0.35)),
              for (int i = 0; i < projects.length; i++)
                if (i != selectedProjectIndex)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onSelect(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                        child: _ProjectRow(item: projects[i], showChevron: false, isMenuOpen: false),
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  const _ProjectRow({required this.item, required this.showChevron, required this.isMenuOpen});

  final DocumentProjectEntity item;
  final bool showChevron;
  final bool isMenuOpen;

  @override
  Widget build(BuildContext context) {
    final fallback = AssetsImages.constructionIgm;
    final thumb = item.thumbnailUrl?.trim() ?? "";

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 40,
            width: 70,
            child: thumb.isNotEmpty
                ? Image.network(
                    thumb,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(fallback, fit: BoxFit.cover),
                  )
                : Image.asset(fallback, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.projectName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Text(
                item.projectAddress,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF9BA8AE), fontSize: 10),
              ),
            ],
          ),
        ),
        if (showChevron)
          Icon(isMenuOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: const Color(0xFFD2A75D), size: 22),
      ],
    );
  }
}
