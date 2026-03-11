import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';
import 'package:stephen_farmer/feature/documents/domain/entities/document_project_entity.dart';
import 'package:stephen_farmer/feature/documents/presentation/view/document_preview_view.dart';
import 'package:stephen_farmer/feature/documents/presentation/widgets/recent_document_item_card.dart';

class DocumentTypeListView extends StatelessWidget {
  const DocumentTypeListView({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<RecentDocumentEntity> items;

  @override
  Widget build(BuildContext context) {
    final role = Get.find<LoginController>().role.value;
    final isInterior = RoleBgColor.isInterior(role);
    final titleColor = isInterior ? const Color(0xFF040404) : Colors.white;
    final displayTitle = _sanitizeTitle(title);
    final pageColor = isInterior ? const Color(0xFFB0ACA0) : Colors.black;
    final bool showBackButton =
        defaultTargetPlatform == TargetPlatform.android;

    return Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Container(
          color: pageColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Column(
              children: [
                SizedBox(
                  height: 44,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 44,
                        child: showBackButton
                            ? IconButton(
                                onPressed: Get.back,
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 20,
                                  color: titleColor,
                                ),
                              )
                            : null,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            displayTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              color: titleColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            'No $displayTitle documents found.',
                            style: GoogleFonts.manrope(
                              color: isInterior
                                  ? const Color(0xFF46413A)
                                  : const Color(0xFFD5DDE1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return RecentDocumentItemCard(
                              item: items[index],
                              onTap: () => Get.to(
                                () => DocumentPreviewView(item: items[index]),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _sanitizeTitle(String raw) {
    return raw
        .replaceAll('ø', 'o')
        .replaceAll('Ø', 'O')
        .replaceAll(RegExp(r'[\u0338\u2044\u2215]'), '')
        .trim();
  }
}
