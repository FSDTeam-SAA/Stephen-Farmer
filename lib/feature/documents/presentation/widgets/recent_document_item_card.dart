import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/core/utils/images.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';

import '../../domain/entities/document_project_entity.dart';

class RecentDocumentItemCard extends StatelessWidget {
  const RecentDocumentItemCard({super.key, required this.item});

  final RecentDocumentEntity item;

  @override
  Widget build(BuildContext context) {
    final role = Get.find<LoginController>().role.value;
    final isInterior = RoleBgColor.isInterior(role);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isInterior ? null : const Color(0xFFE0DFDD),
        gradient: isInterior
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(226, 221, 215, 1),
                  Color.fromRGBO(144, 137, 120, 1),
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isInterior
              ? const Color.fromRGBO(109, 111, 115, 1)
              : const Color(0xFFBFC3C5),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E5DD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(AssetsImages.invoices2, fit: BoxFit.fill),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 168,
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF161D1E),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    SizedBox(
                      width: 69,
                      child: Text(
                        item.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF161D1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF161D1E),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 69,
                      child: Text(
                        item.dateLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF161D1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
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
          SizedBox(
            height: 20,
            width: 20,
            child: Image.asset(
              AssetsImages.download,
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
