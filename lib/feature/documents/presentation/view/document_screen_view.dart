import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/core/common/widgets/category_dropdown_widget.dart';
import 'package:stephen_farmer/core/utils/images.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';
import 'package:stephen_farmer/feature/documents/domain/entities/document_project_entity.dart';

import '../controller/document_controller.dart';
import '../widgets/document_category_card.dart';
import '../widgets/recent_document_item_card.dart';
import 'document_type_list_view.dart';

class DocumentScreenView extends GetView<DocumentController> {
  const DocumentScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final project = controller.selectedProject;
      final role = Get.find<LoginController>().role.value;
      final isInterior = RoleBgColor.isInterior(role);
      final titleColor = isInterior ? const Color(0xFF040404) : Colors.white;
      final subtitleColor = isInterior ? const Color(0xFF46413A) : const Color(0xFFD5DDE1);

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: RoleBgColor.overlayStyle(role),
        child: Scaffold(
          backgroundColor: RoleBgColor.scaffoldColor(role),
          body: Container(
            decoration: RoleBgColor.decoration(role),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Documents',
                        style: GoogleFonts.manrope(color: titleColor, fontSize: 16, fontWeight: FontWeight.w600, height: 1),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (controller.isLoading.value && project == null)
                      const Expanded(child: Center(child: CircularProgressIndicator()))
                    else if (project == null)
                      Expanded(
                        child: Center(
                          child: Text(
                            controller.errorMessage.value.isEmpty ? 'No document data available' : controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: isInterior ? const Color(0xFF464646) : Colors.white70, fontSize: 14),
                          ),
                        ),
                      )
                    else ...[
                      _buildProjectSelector(isInterior),
                      const SizedBox(height: 12),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: controller.refreshProjects,
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: [
                              _buildSectionHeader(
                                title: 'Documents',
                                subtitle: 'All project files organized by type',
                                titleColor: titleColor,
                                subtitleColor: subtitleColor,
                              ),
                              const SizedBox(height: 10),
                              _buildCategoryGrid(categories: project.categories, allDocuments: project.recentDocuments),
                              const SizedBox(height: 12),
                              _buildSectionHeader(
                                title: 'Recent Documents',
                                subtitle: 'Latest Uploads',
                                titleColor: titleColor,
                                subtitleColor: subtitleColor,
                              ),
                              const SizedBox(height: 8),
                              ...project.recentDocuments.map((item) => RecentDocumentItemCard(item: item)),
                              if (controller.errorMessage.value.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    controller.errorMessage.value,
                                    style: const TextStyle(color: Color(0xFFFF7A7A), fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProjectSelector(bool isInterior) {
    return CategoryDropdownWidget<DocumentProjectEntity>(
      items: controller.projects,
      selectedIndex: controller.selectedProjectIndex.value,
      isMenuOpen: controller.isProjectMenuOpen.value,
      isInteriorTheme: isInterior,
      onToggle: controller.toggleProjectMenu,
      onSelect: controller.selectProject,
      titleBuilder: (item) => item.projectName,
      subtitleBuilder: (item) => item.projectAddress,
      thumbnailBuilder: (item) => item.thumbnailUrl,
      fallbackAsset: AssetsImages.constructionIgm,
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle, required Color titleColor, required Color subtitleColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(color: titleColor, fontSize: 20, fontWeight: FontWeight.w600, height: 1),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.manrope(color: subtitleColor, fontSize: 16, fontWeight: FontWeight.w400, height: 1),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid({required List<DocumentCategoryEntity> categories, required List<RecentDocumentEntity> allDocuments}) {
    final visibleCategories = categories.take(4).toList();

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visibleCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        mainAxisExtent: 130,
      ),
      itemBuilder: (_, index) {
        final category = visibleCategories[index];
        return DocumentCategoryCard(
          item: category,
          onTap: () {
            final items = _filterByCategory(category: category, allDocuments: allDocuments);
            Get.to(() => DocumentTypeListView(title: category.title, items: items));
          },
        );
      },
    );
  }

  List<RecentDocumentEntity> _filterByCategory({
    required DocumentCategoryEntity category,
    required List<RecentDocumentEntity> allDocuments,
  }) {
    final byType = _normalizeCategoryKey(category.type);
    final byTitle = _normalizeCategoryKey(category.title);

    return allDocuments.where((doc) {
      final docCategory = _normalizeCategoryKey(doc.category);
      return docCategory == byType || docCategory == byTitle;
    }).toList();
  }

  String _normalizeCategoryKey(String raw) {
    final cleaned = raw.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '').trim();

    if (cleaned.startsWith('draw')) return 'drawings';
    if (cleaned.startsWith('invoice') || cleaned.startsWith('bill')) {
      return 'invoices';
    }
    if (cleaned.startsWith('report')) return 'reports';
    if (cleaned.startsWith('contract') || cleaned.startsWith('agreement')) {
      return 'contracts';
    }

    return cleaned;
  }
}
