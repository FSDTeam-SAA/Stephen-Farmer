import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stephen_farmer/core/colors/app_color.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/core/common/widgets/category_dropdown_widget.dart';
import 'package:stephen_farmer/core/utils/images.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';
import 'package:stephen_farmer/feature/notifications/presentation/view/notification_screen_view.dart';
import 'package:stephen_farmer/feature/update/data/model/update_model.dart';
import 'package:stephen_farmer/feature/update/presentation/controller/update_controller.dart';
import 'package:stephen_farmer/feature/update/presentation/view/add_update_screen_view.dart';
import 'package:stephen_farmer/feature/update/presentation/widgets/update_card.dart';

class UpdateScreenView extends StatelessWidget {
  final String loginCategory;

  const UpdateScreenView({super.key, required this.loginCategory});

  Widget _emptyState({required bool isInterior, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isInterior ? const Color(0xFF1D1D1D) : Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _createUpdateCard({
    required bool isInterior,
    required UpdateController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (controller.selectedProjectId.isEmpty) {
            Get.snackbar('Error', 'Select a project first');
            return;
          }
          Get.to(
            () => AddUpdateScreenView(
              projectId: controller.selectedProjectId,
              onPostSuccess: controller.refreshAll,
              isInteriorTheme: isInterior,
            ),
          );
        },
        child: Container(
          height: 72,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isInterior ? const Color(0xFFE7DED0) : Colors.transparent,
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
              children: [
                CircleAvatar(
                  backgroundColor: isInterior
                      ? const Color(0xFFD6CCB9)
                      : const Color(0xFF2D3232),
                  child: Icon(
                    Icons.photo_camera_rounded,
                    size: 18,
                    color: isInterior
                        ? const Color(0xFF5A5246)
                        : const Color(0xFFD7C5A4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Update',
                            style: GoogleFonts.manrope(
                              color: isInterior
                                  ? const Color(0xFF2F2A24)
                                  : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                          Text(
                            'Share progress from the site',
                            style: GoogleFonts.manrope(
                              color: isInterior
                                  ? const Color(0xFF6E6860)
                                  : const Color(0xFF8E8E93),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.add_circle_outline,
                        size: 24,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateController());
    final authController = Get.find<LoginController>();

    return Obx(() {
      final isInterior = loginCategory.toLowerCase() == 'interior';
      final isManager = authController.normalizedRoleKey == 'manager';

      final projectItems = controller.projects.toList();
      final selectedProjectIndex = controller.selectedProjectIndex.value;
      final safeProjectSelectedIndex = projectItems.isEmpty
          ? 0
          : selectedProjectIndex.clamp(0, projectItems.length - 1);
      final isProjectMenuOpen = controller.isProjectMenuOpen.value;

      final categoryItems = controller.categoryFilters.toList();
      final selectedCategoryIndex = categoryItems.indexOf(
        controller.selectedCategory.value,
      );
      final safeCategorySelectedIndex = selectedCategoryIndex < 0
          ? 0
          : selectedCategoryIndex;
      final isCategoryMenuOpen = controller.isCategoryMenuOpen.value;

      final filteredList = controller.filteredUpdates;
      final notificationIconColor = isInterior
          ? const Color(0xFF1D1D1D)
          : const Color(0xFFC9B089);
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
                        const Spacer(),
                        IconButton(
                          tooltip: 'Notifications',
                          onPressed: () {
                            Get.to(() => const NotificationScreenView());
                          },
                          icon: Icon(
                            Icons.notifications_rounded,
                            color: notificationIconColor,
                            size: 24,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Logout',
                          icon: Icon(
                            Icons.logout_rounded,
                            color: logoutIconColor,
                          ),
                          onPressed: () async {
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) {
                                final dialogBorderColor = isInterior
                                    ? const Color.fromRGBO(109, 111, 115, 1)
                                    : const Color(0xFF5D6570);
                                final dialogBackground = isInterior
                                    ? const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromRGBO(226, 221, 215, 1),
                                          Color.fromRGBO(144, 137, 120, 1),
                                        ],
                                      )
                                    : const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFF0F1A20),
                                          Color(0xFF0A141A),
                                        ],
                                      );
                                final promptColor = isInterior
                                    ? const Color(0xFF040404)
                                    : Colors.white;
                                final accentColor = isInterior
                                    ? const Color(0xFF8E6500)
                                    : const Color(0xFFAF8C6A);

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
                                        color: dialogBorderColor,
                                        width: 2,
                                      ),
                                      gradient: dialogBackground,
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
                                          'Are you sure ?',
                                          style: GoogleFonts.manrope(
                                            color: promptColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 44,
                                                child: OutlinedButton(
                                                  onPressed: () => Navigator.of(
                                                    dialogContext,
                                                  ).pop(false),
                                                  style: OutlinedButton.styleFrom(
                                                    foregroundColor:
                                                        accentColor,
                                                    side: BorderSide(
                                                      color: accentColor,
                                                      width: 1,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Cancel',
                                                    style: GoogleFonts.manrope(
                                                      color: accentColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: SizedBox(
                                                height: 44,
                                                child: ElevatedButton(
                                                  onPressed: () => Navigator.of(
                                                    dialogContext,
                                                  ).pop(true),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        accentColor,
                                                    foregroundColor:
                                                        Colors.white,
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Yes',
                                                    style: GoogleFonts.manrope(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
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
                      'Active Project',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isInterior ? Colors.black : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (controller.isLoading.value && projectItems.isEmpty)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (projectItems.isEmpty)
                      Expanded(
                        child: _emptyState(
                          isInterior: isInterior,
                          message: controller.errorMessage.value.isEmpty
                              ? 'No project available'
                              : controller.errorMessage.value,
                        ),
                      )
                    else
                      Expanded(
                        child: Column(
                          children: [
                            CategoryDropdownWidget<UpdateProjectModel>(
                              items: projectItems,
                              selectedIndex: safeProjectSelectedIndex,
                              isMenuOpen: isProjectMenuOpen,
                              isInteriorTheme: isInterior,
                              onToggle: controller.toggleProjectMenu,
                              onSelect: controller.selectProject,
                              titleBuilder: (item) => item.name,
                              subtitleBuilder: (item) => item.address,
                              thumbnailBuilder: (item) => item.thumbnailUrl,
                              fallbackAsset: AssetsImages.constructionIgm,
                              thumbnailWidth: 70,
                              thumbnailHeight: 39,
                              thumbnailBorderRadius: 4,
                              subtitleColor: isInterior
                                  ? const Color(0xFF6E6860)
                                  : const Color(0xFF8E8E93),
                              titleTextStyle: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                              subtitleTextStyle: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                            if (controller.shouldShowCategoryDropdown) ...[
                              const SizedBox(height: 10),
                              CategoryDropdownWidget<String>(
                                items: categoryItems,
                                selectedIndex: safeCategorySelectedIndex,
                                isMenuOpen: isCategoryMenuOpen,
                                isInteriorTheme: isInterior,
                                onToggle: controller.toggleCategoryMenu,
                                onSelect: (index) => controller.selectCategory(
                                  categoryItems[index],
                                ),
                                titleBuilder: (item) => item,
                                subtitleBuilder: (item) =>
                                    'Filter updates by $item',
                                thumbnailBuilder: (_) => null,
                                fallbackAsset: AssetsImages.constructionIgm,
                                thumbnailWidth: 0,
                                thumbnailHeight: 0,
                                rowPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                minHeight: 46,
                              ),
                            ],
                            if (isManager) ...[
                              const SizedBox(height: 10),
                              _createUpdateCard(
                                isInterior: isInterior,
                                controller: controller,
                              ),
                            ],
                            const SizedBox(height: 10),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: controller.refreshAll,
                                child: filteredList.isEmpty
                                    ? ListView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        children: [
                                          const SizedBox(height: 24),
                                          _emptyState(
                                            isInterior: isInterior,
                                            message: 'No updates found',
                                          ),
                                        ],
                                      )
                                    : ListView.separated(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: filteredList.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 14),
                                        itemBuilder: (_, index) {
                                          final item = filteredList[index];
                                          return UpdatePostCard(
                                            item: item,
                                            isInteriorTheme: isInterior,
                                            onLike: () =>
                                                controller.toggleLike(item),
                                            onShare: () => _shareUpdate(
                                              context: context,
                                              controller: controller,
                                              item: item,
                                            ),
                                            onComment: () => _showCommentsSheet(
                                              context: context,
                                              controller: controller,
                                              updateId: item.id,
                                              isInterior: isInterior,
                                            ),
                                          );
                                        },
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

  Future<void> _showCommentsSheet({
    required BuildContext context,
    required UpdateController controller,
    required String updateId,
    required bool isInterior,
  }) async {
    final textController = TextEditingController();
    final comments = await controller.fetchComments(updateId);

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isInterior
          ? const Color(0xFFF2EFE8)
          : const Color(0xFF111B21),
      builder: (sheetContext) {
        final localComments = List<UpdateCommentModel>.from(comments);
        bool isSending = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 14,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 14,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(
                        color: isInterior ? Colors.black : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: localComments.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'No comments yet',
                                style: TextStyle(
                                  color: isInterior
                                      ? const Color(0xFF555555)
                                      : Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: localComments.length,
                              itemBuilder: (_, index) {
                                final comment = localComments[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundImage: NetworkImage(
                                          comment.userAvatar
                                                      ?.trim()
                                                      .isNotEmpty ==
                                                  true
                                              ? comment.userAvatar!.trim()
                                              : 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comment.userName,
                                              style: TextStyle(
                                                color: isInterior
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              comment.text,
                                              style: TextStyle(
                                                color: isInterior
                                                    ? const Color(0xFF333333)
                                                    : Colors.white70,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        _timeLabel(comment.createdAt),
                                        style: TextStyle(
                                          color: isInterior
                                              ? const Color(0xFF7A7A7A)
                                              : Colors.white54,
                                          fontSize: 11,
                                        ),
                                      ),
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
                            style: TextStyle(
                              color: isInterior ? Colors.black : Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Write a comment...',
                              hintStyle: TextStyle(
                                color: isInterior
                                    ? const Color(0xFF777777)
                                    : Colors.white54,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                                  final added = await controller.addComment(
                                    updateId: updateId,
                                    comment: text,
                                  );
                                  if (added != null) {
                                    textController.clear();
                                    setState(() {
                                      localComments.add(added);
                                    });
                                  }
                                  setState(() => isSending = false);
                                },
                          icon: Icon(
                            Icons.send_rounded,
                            color: isInterior
                                ? const Color(0xFF8E6500)
                                : const Color(0xFFD09A2F),
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
      },
    );
  }

  Future<void> _shareUpdate({
    required BuildContext context,
    required UpdateController controller,
    required UpdateModel item,
  }) async {
    await controller.shareUpdate(item);

    final lines = <String>[
      item.title.trim().isEmpty ? 'Project Update' : item.title.trim(),
      if (item.description.trim().isNotEmpty) item.description.trim(),
      if (item.thumbnailUrl?.trim().isNotEmpty ?? false)
        item.thumbnailUrl!.trim(),
    ];

    try {
      await Share.share(lines.join('\n'));
    } catch (_) {
      if (!context.mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      await Clipboard.setData(ClipboardData(text: lines.join('\n')));
      messenger.showSnackBar(
        const SnackBar(content: Text('Share text copied to clipboard')),
      );
    }
  }

  String _timeLabel(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
