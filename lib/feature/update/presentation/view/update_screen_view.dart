import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stephen_farmer/core/colors/app_color.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/core/common/widgets/category_dropdown_widget.dart';
import 'package:stephen_farmer/core/utils/images.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';
import 'package:stephen_farmer/feature/update/data/model/update_model.dart';
import 'package:stephen_farmer/feature/update/presentation/controller/update_controller.dart';
import 'package:stephen_farmer/feature/update/presentation/view/add_update_screen_view.dart';
import 'package:stephen_farmer/feature/update/presentation/widgets/update_card.dart';

class UpdateScreenView extends StatelessWidget {
  final String loginCategory;

  const UpdateScreenView({super.key, required this.loginCategory});

  static const Map<String, String> _categoryThumbnailUrls = {
    "foundation":
        "https://images.unsplash.com/photo-1591825729269-caeb344f6df2?w=600&auto=format&fit=crop",
    "electrical":
        "https://images.unsplash.com/photo-1621905252507-b35492cc74b4?w=600&auto=format&fit=crop",
    "interior":
        "https://images.unsplash.com/photo-1616594039964-3f74d7c6a99c?w=600&auto=format&fit=crop",
    "plumbing":
        "https://images.unsplash.com/photo-1585704032915-c3400ca199e7?w=600&auto=format&fit=crop",
    "finishing":
        "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=600&auto=format&fit=crop",
    "exterior":
        "https://images.unsplash.com/photo-1600585154526-990dced4db0d?w=600&auto=format&fit=crop",
    "landscaping":
        "https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=600&auto=format&fit=crop",
    "hvac":
        "https://images.unsplash.com/photo-1581093458791-9f3c3900df4b?w=600&auto=format&fit=crop",
    "safety":
        "https://images.unsplash.com/photo-1581092921461-eab62e97a780?w=600&auto=format&fit=crop",
    "roofing":
        "https://images.unsplash.com/photo-1600047509782-20d39509f26d?w=600&auto=format&fit=crop",
    "default":
        "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=600&auto=format&fit=crop",
  };

  UpdateModel _resolveUpdatePreview(String item, List<UpdateModel> updates) {
    if (updates.isEmpty) {
      return UpdateModel(category: item, title: item, description: "");
    }

    final preview = item.toLowerCase() == "all"
        ? updates.first
        : updates.firstWhere(
            (e) => e.category.trim().toLowerCase() == item.trim().toLowerCase(),
            orElse: () => updates.first,
          );

    return UpdateModel(
      category: preview.category,
      title: preview.title,
      description: preview.description,
      thumbnailUrl: preview.thumbnailUrl,
    );
  }

  String? _resolvePreviewImageUrl(String item, List<UpdateModel> updates) {
    final preview = _resolveUpdatePreview(item, updates);
    final thumbnail = preview.thumbnailUrl?.trim() ?? "";
    if (thumbnail.isNotEmpty) {
      return thumbnail;
    }
    return _categoryThumbnailUrls[item.trim().toLowerCase()] ??
        _categoryThumbnailUrls["default"];
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateController());
    final authController = Get.find<LoginController>();

    return Obx(() {
      final isInterior = loginCategory.toLowerCase() == "interior";
      final isManager = authController.normalizedRoleKey == 'manager';
      final items = controller.categoryFilters.toList();
      final selectedIndex = items.indexOf(controller.selectedCategory.value);
      final safeSelectedIndex = selectedIndex < 0 ? 0 : selectedIndex;
      final filteredList = controller.filteredUpdates;
      final isCategoryMenuOpen = controller.isCategoryMenuOpen.value;

      return Scaffold(
        backgroundColor: RoleBgColor.scaffoldColor(loginCategory),
        body: SafeArea(
          child: Container(
            decoration: RoleBgColor.decoration(loginCategory),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      isInterior
                          ? Image.asset(
                              AssetsImages.interiorImg,
                              height: 50,
                              width: 54,
                            )
                          : Image.asset(
                              AssetsImages.constructionIgm,
                              height: 32,
                              width: 87,
                            ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(() {
                          final isInteriorRole = authController.isInterior;
                          final roleLabel =
                              authController.normalizedRoleKey == 'manager'
                              ? 'Manager'
                              : 'User';
                          return Text(
                            "${isInteriorRole ? "Interior" : "Construction"} $roleLabel",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isInterior ? Colors.black : Colors.white,
                            ),
                          );
                        }),
                      ),
                      IconButton(
                        tooltip: "Logout",
                        icon: Icon(
                          Icons.logout_rounded,
                          color: isInterior ? Colors.black : Colors.amber,
                        ),
                        onPressed: () async {
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    16,
                                    16,
                                    18,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: const Color(0xFF5D6570),
                                      width: 2,
                                    ),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF0F1A20),
                                        Color(0xFF0A141A),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        AssetsImages.logout,
                                        height: 48,
                                        width: 48,
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        "Are you sure ?",
                                        style: GoogleFonts.manrope(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 159.5,
                                            height: 44,
                                            child: OutlinedButton(
                                              onPressed: () => Navigator.of(
                                                dialogContext,
                                              ).pop(false),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: const Color(
                                                  0xFFAF8C6A,
                                                ),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                      10,
                                                      12,
                                                      10,
                                                      12,
                                                    ),
                                                side: const BorderSide(
                                                  color: Color(0xFFAF8C6A),
                                                  width: 1,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                "Cancel",
                                                style: GoogleFonts.manrope(
                                                  color: const Color(
                                                    0xFFAF8C6A,
                                                  ),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 159.5,
                                            height: 44,
                                            child: ElevatedButton(
                                              onPressed: () => Navigator.of(
                                                dialogContext,
                                              ).pop(true),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFFAF8C6A,
                                                ),
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                      10,
                                                      12,
                                                      10,
                                                      12,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                "Yes",
                                                style: GoogleFonts.manrope(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                          if (shouldLogout == true) {
                            await authController.logoutUser();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Active Projects",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isInterior ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : controller.updateList.isEmpty
                        ? Center(
                            child: Text(
                              "No Project",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isInterior ? Colors.black : Colors.white,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              if (controller.shouldShowCategoryDropdown)
                                CategoryDropdownWidget<String>(
                                  items: items,
                                  selectedIndex: safeSelectedIndex,
                                  isMenuOpen: isCategoryMenuOpen,
                                  isInteriorTheme: isInterior,
                                  onToggle: controller.toggleCategoryMenu,
                                  onSelect: (index) =>
                                      controller.selectCategory(items[index]),
                                  titleBuilder: (item) => item,
                                  subtitleBuilder: (item) =>
                                      _resolveUpdatePreview(
                                        item,
                                        controller.updateList,
                                      ).title,
                                  thumbnailBuilder: (item) =>
                                      _resolvePreviewImageUrl(
                                        item,
                                        controller.updateList,
                                      ),
                                  fallbackAsset: AssetsImages.constructionIgm,
                                ),
                              const SizedBox(height: 10),
                              if (isManager)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {
                                      Get.to(() => const AddUpdateScreenView());
                                    },
                                    child: Container(
                                      height: 72,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: isInterior
                                            ? const Color(0xFFE7DED0)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: isInterior
                                              ? const Color(0xFF8A7F6C)
                                              : const Color(0xFF2B4756),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              child: Icon(
                                                Icons.photo_camera_rounded,
                                                size: 18,
                                                color: isInterior
                                                    ? const Color(0xFF2E2E2E)
                                                    : Colors.grey.shade300,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Create Update ",
                                                        style: TextStyle(
                                                          color: isInterior
                                                              ? const Color(
                                                                  0xFF2F2A24,
                                                                )
                                                              : Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Share progress from the site",
                                                        style: TextStyle(
                                                          color: isInterior
                                                              ? const Color(
                                                                  0xFF2E2E2E,
                                                                )
                                                              : Colors.white70,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(
                                                    Icons.add_circle_outline,
                                                    size: 30,
                                                    color: AppColor.appColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (isManager) const SizedBox(height: 10),
                              Expanded(
                                child: filteredList.isEmpty
                                    ? Center(
                                        child: Text(
                                          "No updates for this category",
                                          style: TextStyle(
                                            color: isInterior
                                                ? const Color(0xFF464646)
                                                : Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: filteredList.length,
                                        itemBuilder: (_, index) {
                                          return UpdatePostCard(
                                            item: filteredList[index],
                                            isInteriorTheme: isInterior,
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
