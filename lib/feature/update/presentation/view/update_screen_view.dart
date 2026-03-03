import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/images.dart';
import '../../data/model/update_model.dart';
import '../controller/update_controller.dart';
import '../widgets/update_card.dart';
import '../widgets/update_category_dropdown_card.dart';

class UpdateScreenView extends StatelessWidget {
  final String loginCategory;
  final String userRole;
  const UpdateScreenView({
    super.key,
    required this.loginCategory,
    required this.userRole,
  });

  CategoryPreviewData _resolveUpdatePreview(
    String item,
    List<UpdateModel> updates,
  ) {
    if (updates.isEmpty) {
      return CategoryPreviewData(category: item, title: item, description: "");
    }

    final UpdateModel preview = item.toLowerCase() == "all"
        ? updates.first
        : updates.firstWhere(
            (e) => e.category.trim().toLowerCase() == item.trim().toLowerCase(),
            orElse: () => updates.first,
          );

    return CategoryPreviewData(
      category: preview.category,
      title: preview.title,
      description: preview.description,
      thumbnailUrl: preview.thumbnailUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateController());

    return Obx(() {
      final isInterior = loginCategory.toLowerCase() == "interior";
      final isClientInterior =
          userRole.toLowerCase() == "client" && isInterior;

      return Scaffold(
        backgroundColor: isInterior ? Colors.transparent : Colors.black,
        body: SafeArea(
          child: Container(
            decoration: isInterior
                ? const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffE6E1DB), Color(0xff847C69)],
                    ),
                  )
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isInterior
                          ? Image.asset(AssetsImages.interiorImg, height: 50, width: 54)
                          : Image.asset(AssetsImages.constructionIgm, height: 32, width: 87),
                      const Icon(Icons.notifications, color: Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Expanded(
                    child: controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : controller.updateList.isEmpty
                        ? Center(
                            child: Text(
                              "No Project",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isInterior ? Colors.black : Colors.white),
                            ),
                          )
                        : Column(
                            children: [
                              /// Show dropdown only when API returns more than one category.
                              if (controller.shouldShowCategoryDropdown)
                                UpdateCategoryDropdownCard(
                                  isInterior: isInterior,
                                  items: controller.categoryFilters.toList(),
                                  selectedItem: controller.selectedCategory.value,
                                  isMenuOpen: controller.isCategoryMenuOpen.value,
                                  previewBuilder: (item) =>
                                      _resolveUpdatePreview(item, controller.updateList.toList()),
                                  onToggle: controller.toggleCategoryMenu,
                                  onSelect: controller.selectCategory,
                                ),

                              const SizedBox(height: 10),

                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    final filteredList = controller.filteredUpdates;

                                    return ListView.builder(
                                      itemCount: filteredList.length,
                                      itemBuilder: (_, index) {
                                        return UpdatePostCard(
                                          isClientInterior: isClientInterior,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
