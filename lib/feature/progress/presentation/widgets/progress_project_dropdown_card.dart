import 'package:flutter/material.dart';
import 'package:stephen_farmer/core/utils/images.dart';

import '../../domain/entities/progress_entity.dart';

class ProgressProjectDropdownCard extends StatelessWidget {
  const ProgressProjectDropdownCard({
    super.key,
    required this.projects,
    required this.selectedProjectIndex,
    required this.isMenuOpen,
    required this.onToggle,
    required this.onSelect,
  });

  final List<ProjectProgressEntity> projects;
  final int selectedProjectIndex;
  final bool isMenuOpen;
  final VoidCallback onToggle;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) return const SizedBox.shrink();

    final int selectedIndex = selectedProjectIndex.clamp(0, projects.length - 1);
    final ProjectProgressEntity selectedProject = projects[selectedIndex];
    const cardBorder = Color(0xFFB9A77D);
    const cardBg = Color(0xFF111A1E);
    final bool canExpand = projects.length > 1;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardBorder.withValues(alpha: 0.55)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onToggle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: _ProjectMenuRow(
                    model: selectedProject,
                    showChevron: canExpand,
                    isMenuOpen: isMenuOpen,
                  ),
                ),
              ),
            ),
            if (isMenuOpen && canExpand) ...[
              Divider(
                height: 1,
                thickness: 1,
                color: cardBorder.withValues(alpha: 0.35),
              ),
              for (int i = 0; i < projects.length; i++)
                if (i != selectedIndex)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onSelect(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: _ProjectMenuRow(
                          model: projects[i],
                          showChevron: false,
                          isMenuOpen: false,
                        ),
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

class _ProjectMenuRow extends StatelessWidget {
  const _ProjectMenuRow({
    required this.model,
    required this.showChevron,
    required this.isMenuOpen,
  });

  final ProjectProgressEntity model;
  final bool showChevron;
  final bool isMenuOpen;

  @override
  Widget build(BuildContext context) {
    final thumb = model.thumbnailUrl?.trim() ?? "";
    final fallbackAsset = AssetsImages.constructionIgm;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 40,
            width: 72,
            child: thumb.isNotEmpty
                ? Image.network(
                    thumb,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(fallbackAsset, fit: BoxFit.cover),
                  )
                : Image.asset(fallbackAsset, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                model.address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFB5C0C5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        if (showChevron)
          Icon(
            isMenuOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
            color: const Color(0xFFE3D2AA),
            size: 24,
          ),
      ],
    );
  }
}
