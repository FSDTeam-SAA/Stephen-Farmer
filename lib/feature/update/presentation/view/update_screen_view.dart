import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';
import '../../../../core/common/widgets/scope_gate.dart';
import '../../../../core/common/widgets/scope_text_color.dart';
import '../../../../core/utils/images.dart';
import '../../data/model/update_model.dart';
import '../controller/update_controller.dart';
import '../widgets/update_card.dart';
import '../widgets/update_category_dropdown_card.dart';

class UpdateScreenView extends StatelessWidget {
  final String loginCategory;
  const UpdateScreenView({super.key, required this.loginCategory});

  CategoryPreviewData _resolveUpdatePreview(String item, List<UpdateModel> updates) {
    if (updates.isEmpty) {
      return CategoryPreviewData(category: item, title: item, description: "");
    }

    final UpdateModel preview = item.toLowerCase() == "all"
        ? updates.first
        : updates.firstWhere((e) => e.category.trim().toLowerCase() == item.trim().toLowerCase(), orElse: () => updates.first);

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
    final authController = Get.find<LoginController>();

    return Obx(() {
      final isInterior = loginCategory.toLowerCase() == "interior";

      return Scaffold(
        backgroundColor: RoleBgColor.scaffoldColor(loginCategory),
        body: SafeArea(
          child: Container(
            decoration: RoleBgColor.decoration(loginCategory),
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

                      /*  Text(
                        "${isInterior ? "Interior" : "Construction"} ",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isInterior ? Colors.black : Colors.white),
                      ), */
                      Obx(() {
                        final isInterior = authController.isInterior;
                        final roleLabel = authController.normalizedRoleKey == 'manager' ? 'Manager' : 'User';

                        return Text(
                          "${isInterior ? "Interior" : "Construction"} $roleLabel",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isInterior ? Colors.black : Colors.white),
                        );
                      }),
                      IconButton(
                        tooltip: "Logout",
                        icon: Icon(Icons.logout_rounded, color: isInterior ? Colors.black : Colors.amber),
                        onPressed: () async {
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                backgroundColor: isInterior ? const Color(0xFFE8E1D4) : const Color(0xFF121A20),
                                title: Text("Logout", style: TextStyle(color: isInterior ? Colors.black : Colors.white)),
                                content: Text(
                                  "Are you sure you want to logout?",
                                  style: TextStyle(color: isInterior ? Colors.black87 : Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(dialogContext).pop(false),
                                    child: Text("Cancel", style: TextStyle(color: isInterior ? Colors.black87 : Colors.white70)),
                                  ),
                                  TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text("Logout")),
                                ],
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
                  const SizedBox(height: 30),

                  /*   ScopeGate(
                    // scope: 'construction_manager',
                    anyScopes: ['construction_manager', 'interior_manager'],
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      color: isInterior ? const Color.fromARGB(255, 23, 159, 69) : const Color.fromARGB(255, 9, 63, 105),
                      child: Text("Only Construction Manager", style: TextStyle(color: ScopeStyles.textColor(authController.scopeKey))),
                    ),
                  ), */
                  /*   Container(
                    height: 150,
                    decoration: isInterior ? RoleBgColor.interiorDecoration : const BoxDecoration(color: Colors.black),
                    child: Text(
                      "Construction Manager Only Banner - This section is visible only to users with the 'construction_manager' scope. It demonstrates role-based access control in the UI.",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ScopeStyles.textColor(authController.scopeKey)),
                    ),
                  ), */
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
                                  previewBuilder: (item) => _resolveUpdatePreview(item, controller.updateList.toList()),
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
                                        return UpdatePostCard(isInteriorTheme: isInterior);
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
