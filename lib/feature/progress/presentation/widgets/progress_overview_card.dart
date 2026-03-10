import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stephen_farmer/core/utils/images.dart';

import '../../domain/entities/progress_entity.dart';

class ProgressOverviewCard extends StatelessWidget {
  const ProgressOverviewCard({super.key, required this.project});

  final ProjectProgressEntity project;

  @override
  Widget build(BuildContext context) {
    final fallbackAsset = AssetsImages.constructionIgm;
    final startedLabel = _formatDateLabel(
      project.startedDate,
      longMonth: false,
    );
    final handoverLabel = _formatDateLabel(
      project.handoverDate,
      longMonth: true,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: const Color(0xFF111A1E),
          border: Border.all(
            color: const Color(0xFFB9A77D).withValues(alpha: 0.2),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              project.heroImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Image.asset(fallbackAsset, fit: BoxFit.cover),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3D2AA),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Active Project',
                  style: TextStyle(
                    color: Color(0xFF151515),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 66,
              left: 16,
              right: 16,
              child: Text(
                project.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'ClashDisplay',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Overall completion',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 19 / 14,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${project.overallCompletion}%',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'ClashDisplay',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1,
                          letterSpacing: 0,
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
                    children: [
                      Expanded(
                        child: Text(
                          'Started: $startedLabel',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            color: Color(0xFFD4D4D4),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'EST. Handover: $handoverLabel',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.manrope(
                            color: Color(0xFFD4D4D4),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1,
                            letterSpacing: 0,
                          ),
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

String _formatDateLabel(String raw, {required bool longMonth}) {
  final value = raw.trim();
  if (value.isEmpty) return raw;

  final parsed = DateTime.tryParse(value);
  if (parsed == null) return raw;

  const shortMonths = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  const longMonths = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final months = longMonth ? longMonths : shortMonths;
  final month = months[parsed.month - 1];
  return '$month ${parsed.day}';
}
