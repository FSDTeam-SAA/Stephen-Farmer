import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/core/utils/images.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';

import '../../domain/entities/task_project_entity.dart';

class TaskDetailsScreenView extends StatelessWidget {
  const TaskDetailsScreenView({
    super.key,
    required this.item,
    this.waitingForApproval = false,
  });

  final TaskItemEntity item;
  final bool waitingForApproval;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<LoginController>();
    final role = authController.role.value;
    final bool isInterior = RoleBgColor.isInterior(role);

    final Color bgColor = isInterior
        ? const Color(0xFFE4DED2)
        : const Color(0xFF0F161C);
    final Color cardColor = isInterior
        ? const Color(0xFFD5D2CA)
        : const Color(0xFF111A1E);
    final Color titleColor = isInterior
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    final bool showBackButton =
        defaultTargetPlatform == TargetPlatform.android;
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showBackButton) ...[
                      Row(
                        children: [
                          IconButton(
                            onPressed: Get.back,
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: titleColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    _PriorityChip(priority: item.priority),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: 335,
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: titleColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          height: 1,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 335,
                      height: 32,
                      child: Text(
                        item.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF8E8E93),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: 335,
                      height: 20,
                      child: Text(
                        'See Photos (4)',
                        style: GoogleFonts.outfit(
                          color: titleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 194,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, __) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            AssetsImages.constructionIgm,
                            width: 219,
                            height: 194,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 335,
                      height: 20,
                      child: Text(
                        'Messages',
                        style: GoogleFonts.outfit(
                          color: titleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (!waitingForApproval) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Color(0xFF8EA0AE),
                                  child: Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 255,
                                            height: 17,
                                            child: Text.rich(
                                              TextSpan(
                                                text: 'Rain Altmann ',
                                                style: GoogleFonts.manrope(
                                                  color: titleColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.4,
                                                  letterSpacing: 0,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: '(Site manager)',
                                                    style: GoogleFonts.manrope(
                                                      color: titleColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.4,
                                                      letterSpacing: 0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: 255,
                                        height: 40,
                                        child: Text(
                                          'Sure, that\'s done. The update has been applied.',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.manrope(
                                            color: titleColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.4,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isInterior
                                ? const Color(0xFFB7A084)
                                : const Color(0xFF1B262D),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Great, thank you.',
                            style: GoogleFonts.manrope(
                              color: titleColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B262D),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: SizedBox(
                            width: 143,
                            height: 40,
                            child: Text(
                              'The update has been applied.',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xFF8EA0AE),
                            child: Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 255,
                                  height: 17,
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'Rain Altmann ',
                                      style: GoogleFonts.manrope(
                                        color: titleColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                        letterSpacing: 0,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '(Client)',
                                          style: GoogleFonts.manrope(
                                            color: titleColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            height: 1.4,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Great, thank you.',
                                  style: GoogleFonts.manrope(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                waitingForApproval ? 8 : 12,
                16,
                waitingForApproval ? 8 : 16,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                border: const Border(
                  top: BorderSide(color: Color(0xFF26333A), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: waitingForApproval ? 40 : 44,
                      child: ElevatedButton(
                        onPressed: waitingForApproval ? null : () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: waitingForApproval
                              ? const Color(0xFF1E2127)
                              : const Color(0xFFB5946E),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF1E2127),
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          waitingForApproval
                              ? 'Waiting for Approval...'
                              : 'Approve & Complete',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: waitingForApproval ? 40 : 44,
                    height: waitingForApproval ? 40 : 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.message,
                      size: 24,
                      color: Color(0xFF8A6B37),
                    ),
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

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    final bool highPriority = priority.trim().toLowerCase() == 'high';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: highPriority ? const Color(0xFFC04141) : const Color(0xFF8A6400),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        priority.toUpperCase(),
        style: GoogleFonts.manrope(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 22 / 12,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
