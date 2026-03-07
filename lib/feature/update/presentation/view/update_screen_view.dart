import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stephen_farmer/core/colors/app_color.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/core/common/widgets/category_dropdown_widget.dart';
import 'package:stephen_farmer/core/utils/images.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';
import 'package:stephen_farmer/feature/update/data/model/update_model.dart';
import 'package:stephen_farmer/feature/notifications/presentation/view/notification_screen_view.dart';
import 'package:stephen_farmer/feature/update/presentation/controller/update_controller.dart';
import 'package:stephen_farmer/feature/update/presentation/view/add_update_screen_view.dart';
import 'package:stephen_farmer/feature/update/presentation/widgets/update_card.dart';

class UpdateScreenView extends StatelessWidget {
  final String loginCategory;

  const UpdateScreenView({super.key, required this.loginCategory});

  Widget _emptyState({required bool isInterior, required String message}) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        decoration: BoxDecoration(
          //color: isInterior ? const Color(0xFFD5D2CA) : const Color(0xFF111A1E),
          //: BorderRadius.circular(12),
          /* border: Border.all(
            color:
                isInterior ? const Color(0xFF77716A) : const Color(0xFFB9A77D),
          ), */
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: isInterior ? const Color(0xFF1D1D1D) : Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _createUpdateCard({required bool isInterior, required UpdateController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (controller.selectedProjectId.isEmpty) {
            Get.snackbar('Error', 'Select a project first');
            return;
          }
          Get.to(() => AddUpdateScreenView(projectId: controller.selectedProjectId, onPostSuccess: controller.refreshAll));
        },
        child: Container(
          height: 72,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isInterior ? const Color(0xFFE7DED0) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isInterior ? const Color(0xFF8A7F6C) : const Color(0xFF2B4756)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(child: Icon(Icons.photo_camera_rounded, size: 18, color: isInterior ? const Color(0xFF2E2E2E) : Colors.grey.shade300)),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create Update ",
                            style: TextStyle(color: isInterior ? const Color(0xFF2F2A24) : Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Share progress from the site",
                            style: TextStyle(color: isInterior ? const Color(0xFF2E2E2E) : Colors.white70, fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Icon(Icons.add_circle_outline, size: 30, color: AppColor.appColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateController());
    final authController = Get.find<LoginController>();

    return Obx(() {
      final isInterior = loginCategory.toLowerCase() == "interior";
      final isManager = authController.normalizedRoleKey == 'manager';
      final project = controller.selectedProject;
      final categoryItems = controller.categoryFilters.toList();
      final selectedCategoryIndex = categoryItems.indexOf(controller.selectedCategory.value);
      final safeCategorySelectedIndex = selectedCategoryIndex < 0 ? 0 : selectedCategoryIndex;
      final filteredList = controller.filteredUpdates;
      final notificationIconColor = isInterior ? const Color(0xFF1D1D1D) : const Color(0xFFC9B089);
      final logoutIconColor = const Color(0xFFF24E4E);

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: RoleBgColor.overlayStyle(loginCategory),
        child: Scaffold(
          backgroundColor: RoleBgColor.scaffoldColor(loginCategory),
          body: Container(
            decoration: RoleBgColor.decoration(loginCategory),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        isInterior ? Image.asset(AssetsImages.interiorImg, height: 50, width: 54) : Image.asset(AssetsImages.constructionIgm, height: 32, width: 87),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Obx(() {
                            final isInteriorRole = authController.isInterior;
                            final roleLabel = authController.normalizedRoleKey == 'manager' ? 'Manager' : 'User';
                            return Text(
                              "${isInteriorRole ? "Interior" : "Construction"} $roleLabel",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isInterior ? Colors.black : Colors.white),
                            );
                          }),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const NotificationScreenView());
                          },
                          child: Icon(Icons.notifications_rounded, color: notificationIconColor, size: 24),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: "Logout",
                          icon: Icon(Icons.logout_rounded, color: logoutIconColor),
                          onPressed: () async {
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) {
                                final dialogBorderColor = isInterior ? const Color(0xFFCFCFCF) : const Color(0xFF5D6570);
                                final dialogBackground = isInterior
                                    ? null
                                    : const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0F1A20), Color(0xFF0A141A)]);
                                final dialogSolidBackground = isInterior ? const Color(0xFFF2F0EC) : null;
                                final promptColor = Colors.white;
                                final accentColor = isInterior ? const Color(0xFF8E6500) : const Color(0xFFAF8C6A);

                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding: const EdgeInsets.symmetric(horizontal: 18),
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(color: dialogBorderColor, width: 2),
                                      color: dialogSolidBackground,
                                      gradient: dialogBackground,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(AssetsImages.logout, height: 48, width: 48),
                                        const SizedBox(height: 14),
                                        Text(
                                          "Are you sure ?",
                                          style: GoogleFonts.manrope(color: promptColor, fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 159.5,
                                              height: 44,
                                              child: OutlinedButton(
                                                onPressed: () => Navigator.of(dialogContext).pop(false),
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: accentColor,
                                                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                                                  side: BorderSide(color: accentColor, width: 1),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                ),
                                                child: Text(
                                                  "Cancel",
                                                  style: GoogleFonts.manrope(color: accentColor, fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: 159.5,
                                              height: 44,
                                              child: ElevatedButton(
                                                onPressed: () => Navigator.of(dialogContext).pop(true),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: accentColor,
                                                  foregroundColor: Colors.white,
                                                  elevation: 0,
                                                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                ),
                                                child: Text(
                                                  "Yes",
                                                  style: GoogleFonts.manrope(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
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
                      "Active Project",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isInterior ? Colors.black : Colors.white),
                    ),
                    const SizedBox(height: 8),
                    if (controller.isLoading.value && !controller.hasProjects)
                      const Expanded(child: Center(child: CircularProgressIndicator()))
                    else if (project == null)
                      Expanded(
                        child: _emptyState(isInterior: isInterior, message: controller.errorMessage.value.isEmpty ? 'No update data available' : controller.errorMessage.value),
                      )
                    else
                      Expanded(
                        child: Column(
                          children: [
                            CategoryDropdownWidget<UpdateProjectModel>(
                              items: controller.projects,
                              selectedIndex: controller.selectedProjectIndex.value,
                              isMenuOpen: controller.isProjectMenuOpen.value,
                              isInteriorTheme: isInterior,
                              onToggle: controller.toggleProjectMenu,
                              onSelect: controller.selectProject,
                              titleBuilder: (item) => item.name,
                              subtitleBuilder: (item) => item.address,
                              thumbnailBuilder: (item) => item.thumbnailUrl,
                              fallbackAsset: AssetsImages.constructionIgm,
                            ),
                            if (controller.shouldShowCategoryDropdown) ...[
                              const SizedBox(height: 10),
                              CategoryDropdownWidget<String>(
                                items: categoryItems,
                                selectedIndex: safeCategorySelectedIndex,
                                isMenuOpen: controller.isCategoryMenuOpen.value,
                                isInteriorTheme: isInterior,
                                onToggle: controller.toggleCategoryMenu,
                                onSelect: (index) => controller.selectCategory(categoryItems[index]),
                                titleBuilder: (item) => item,
                                subtitleBuilder: (item) => 'Filter updates by $item',
                                thumbnailBuilder: (_) => null,
                                fallbackAsset: AssetsImages.constructionIgm,
                                thumbnailWidth: 0,
                                thumbnailHeight: 0,
                                rowPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                minHeight: 46,
                              ),
                            ],
                            const SizedBox(height: 10),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: controller.refreshAll,
                                child: ListView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  children: [
                                    if (isManager) _createUpdateCard(isInterior: isInterior, controller: controller),
                                    if (controller.isLoading.value && controller.updateList.isEmpty)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 24),
                                        child: Center(child: CircularProgressIndicator()),
                                      )
                                    else if (controller.errorMessage.value.isNotEmpty && controller.updateList.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 24),
                                        child: Center(
                                          child: Text(controller.errorMessage.value, style: TextStyle(color: isInterior ? const Color(0xFF464646) : Colors.white70, fontSize: 14)),
                                        ),
                                      )
                                    else if (filteredList.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 24),
                                        child: Center(
                                          child: Text("No updates found", style: TextStyle(color: isInterior ? const Color(0xFF464646) : Colors.white70, fontSize: 14)),
                                        ),
                                      )
                                    else
                                      ...filteredList.map(
                                        (item) => UpdatePostCard(
                                          item: item,
                                          isInteriorTheme: isInterior,
                                          onLike: () => controller.toggleLike(item),
                                          onShare: () => controller.shareUpdate(item),
                                          onComment: () => _showCommentsSheet(context: context, controller: controller, updateId: item.id, isInterior: isInterior),
                                        ),
                                      ),
                                  ],
                                ),
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
        ),
      );
    });
  }

  Future<void> _showCommentsSheet({required BuildContext context, required UpdateController controller, required String updateId, required bool isInterior}) async {
    final textController = TextEditingController();
    final comments = await controller.fetchComments(updateId);

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isInterior ? const Color(0xFFF2EFE8) : const Color(0xFF111B21),
      builder: (sheetContext) {
        final localComments = List<UpdateCommentModel>.from(comments);
        bool isSending = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 14, bottom: MediaQuery.of(context).viewInsets.bottom + 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(color: isInterior ? Colors.black : Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: localComments.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text('No comments yet', style: TextStyle(color: isInterior ? const Color(0xFF555555) : Colors.white70, fontSize: 13)),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: localComments.length,
                              itemBuilder: (_, index) {
                                final comment = localComments[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundImage: NetworkImage(
                                          comment.userAvatar?.trim().isNotEmpty == true
                                              ? comment.userAvatar!.trim()
                                              : 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comment.userName,
                                              style: TextStyle(color: isInterior ? Colors.black : Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                                            ),
                                            Text(comment.text, style: TextStyle(color: isInterior ? const Color(0xFF333333) : Colors.white70, fontSize: 13)),
                                          ],
                                        ),
                                      ),
                                      Text(_timeLabel(comment.createdAt), style: TextStyle(color: isInterior ? const Color(0xFF7A7A7A) : Colors.white54, fontSize: 11)),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            style: TextStyle(color: isInterior ? Colors.black : Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Write a comment...',
                              hintStyle: TextStyle(color: isInterior ? const Color(0xFF777777) : Colors.white54),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: isSending
                              ? null
                              : () async {
                                  final text = textController.text.trim();
                                  if (text.isEmpty) return;
                                  setState(() => isSending = true);
                                  final added = await controller.addComment(updateId: updateId, comment: text);
                                  if (added != null) {
                                    textController.clear();
                                    localComments.add(added);
                                  }
                                  setState(() => isSending = false);
                                },
                          icon: Icon(Icons.send_rounded, color: isInterior ? const Color(0xFF8E6500) : const Color(0xFFD09A2F)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _timeLabel(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
