import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stephen_farmer/core/common/widgets/category_dropdown_widget.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/core/utils/images.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';
import 'package:stephen_farmer/feature/documents/domain/entities/document_project_entity.dart';

import '../controller/document_controller.dart';
import '../widgets/document_category_card.dart';
import '../widgets/recent_document_item_card.dart';

class DocumentScreenView extends GetView<DocumentController> {
  const DocumentScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final project = controller.selectedProject;
      final role = Get.find<LoginController>().role.value;
      final bool isInterior = RoleBgColor.isInterior(role);
      final Color titleColor = isInterior
          ? const Color(0xFF1D1D1D)
          : Colors.white;
      final Color subtitleColor = isInterior
          ? const Color(0xFF46413A)
          : const Color(0xFFD5DDE1);

      return Scaffold(
        backgroundColor: RoleBgColor.scaffoldColor(role),
        body: SafeArea(
          child: Container(
            decoration: RoleBgColor.decoration(role),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Documents',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (controller.isLoading.value && project == null)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (project == null)
                    Expanded(
                      child: Center(
                        child: Text(
                          controller.errorMessage.value.isEmpty
                              ? 'No document data available'
                              : controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isInterior
                                ? const Color(0xFF464646)
                                : Colors.white70,
                            fontSize: 14,
                          ),
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
                            _buildCategoryGrid(project.categories),
                            const SizedBox(height: 12),
                            _buildSectionHeader(
                              title: 'Recent Documents',
                              subtitle: 'Latest Uploads',
                              titleColor: titleColor,
                              subtitleColor: subtitleColor,
                            ),
                            const SizedBox(height: 8),
                            ...project.recentDocuments.map(
                              (item) => RecentDocumentItemCard(item: item),
                            ),
                            if (controller.errorMessage.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(
                                    color: Color(0xFFFF7A7A),
                                    fontSize: 12,
                                  ),
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
      );
    });
  }

  Widget _buildProjectSelector(bool isInterior) {
    return CategoryDropdownWidget(
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

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            color: subtitleColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(List<DocumentCategoryEntity> categories) {
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
        childAspectRatio: 160 / 110,
      ),
      itemBuilder: (_, index) {
        return DocumentCategoryCard(item: visibleCategories[index]);
      },
    );
  }
}
