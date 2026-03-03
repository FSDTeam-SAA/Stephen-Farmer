import 'package:flutter/material.dart';
import 'package:stephen_farmer/core/utils/images.dart';

import '../../domain/entities/progress_entity.dart';

class ProgressOverviewCard extends StatelessWidget {
  const ProgressOverviewCard({
    super.key,
    required this.project,
  });

  final ProjectProgressEntity project;

  @override
  Widget build(BuildContext context) {
    final fallbackAsset = AssetsImages.constructionIgm;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: const Color(0xFF111A1E),
          border: Border.all(color: const Color(0xFFB9A77D).withValues(alpha: 0.2)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              project.heroImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                fallbackAsset,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3D2AA),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Active Project',
                  style: TextStyle(
                    color: Color(0xFF151515),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      height: 1.05,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Overall completion',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${project.overallCompletion}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: project.overallCompletion.clamp(0, 100) / 100,
                      minHeight: 9,
                      backgroundColor: Colors.white,
                      color: const Color(0xFFE3D2AA),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Started: ${project.startedDate}',
                        style: const TextStyle(
                          color: Color(0xFFD7D7D7),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'EST. Handover: ${project.handoverDate}',
                        style: const TextStyle(
                          color: Color(0xFFD7D7D7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
