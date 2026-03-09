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
  static const MethodChannel _nativeShareChannel = MethodChannel(
    'app.share/native',
  );

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
    final cardHeight = isInterior ? 68.0 : 72.0;
    final cardRadius = isInterior ? 8.0 : 10.0;
    final cardPadding = isInterior
        ? const EdgeInsets.symmetric(horizontal: 14, vertical: 10)
        : const EdgeInsets.all(10);
    final badgeSize = isInterior ? 32.0 : 40.0;
    final badgeIconSize = isInterior ? 15.0 : 18.0;
    final titleColor = isInterior ? const Color(0xFF181818) : Colors.white;
    final subtitleColor = isInterior
        ? const Color(0xFF5F5A52)
        : const Color(0xFF8E8E93);
    final cardColor = isInterior ? const Color(0xFFF4F4F2) : Colors.transparent;
    final borderColor = isInterior
        ? const Color(0xFF9F9583)
        : const Color(0xFF2B4756);
    final badgeColor = isInterior
        ? const Color(0xFFF0ECE3)
        : const Color(0xFF2D3232);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(cardRadius),
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
          height: cardHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(cardRadius),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: cardPadding,
            child: Row(
              children: [
                Container(
                  width: badgeSize,
                  height: badgeSize,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.photo_camera_rounded,
                      size: badgeIconSize,
                      color: isInterior
                          ? const Color(0xFFD0B47A)
                          : const Color(0xFFD7C5A4),
                    ),
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
                              color: titleColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                          Text(
                            'Share progress from the site',
                            style: GoogleFonts.manrope(
                              color: subtitleColor,
                              fontSize: isInterior ? 11 : 12,
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(
                          Icons.add_circle_outline,
                          size: 24,
                          color: AppColor.appColor,
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
                          onPressed: () =>
                              Get.to(() => const NotificationScreenView()),
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
                                final accentColor = isInterior
                                    ? const Color(0xFF8E6500)
                                    : const Color(0xFFAF8C6A);
                                final promptColor = isInterior
                                    ? const Color(0xFF040404)
                                    : Colors.white;

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
                        height: 22 / 16,
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
                                child: ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  children: [
                                    if (controller.isLoading.value &&
                                        controller.updateList.isEmpty)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 24),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    else if (controller
                                            .errorMessage
                                            .value
                                            .isNotEmpty &&
                                        controller.updateList.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 24),
                                        child: Center(
                                          child: Text(
                                            controller.errorMessage.value,
                                            style: TextStyle(
                                              color: isInterior
                                                  ? const Color(0xFF464646)
                                                  : Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      )
                                    else if (filteredList.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 24),
                                        child: Center(
                                          child: Text(
                                            'No updates found',
                                            style: TextStyle(
                                              color: isInterior
                                                  ? const Color(0xFF464646)
                                                  : Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      ...filteredList.map(
                                        (item) => UpdatePostCard(
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

  Future<void> _showCommentsSheet({
    required BuildContext context,
    required UpdateController controller,
    required String updateId,
    required bool isInterior,
  }) async {
    final textController = TextEditingController();
    final inputFocusNode = FocusNode();
    final comments = await controller.fetchComments(updateId);

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final localComments = List<UpdateCommentModel>.from(comments);
        bool isSending = false;
        String? replyToName;
        final authController = Get.find<LoginController>();
        final currentUserName = authController.displayName.isEmpty
            ? 'User'
            : authController.displayName;
        final currentUserAvatar = authController.displayAvatar.isEmpty
            ? null
            : authController.displayAvatar;
        final panelColor = isInterior
            ? const Color(0xFFD6D1C7)
            : const Color(0xFF111B21);
        final titleColor = isInterior ? Colors.black : Colors.white;
        final bodyColor = isInterior
            ? const Color(0xFF181818)
            : const Color(0xFFF2F2F2);
        final mutedColor = isInterior
            ? const Color(0xFF4B4B4B)
            : const Color(0xFF8E8E93);

        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              top: false,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: FractionallySizedBox(
                  heightFactor: 0.88,
                  child: Container(
                    decoration: BoxDecoration(
                      color: panelColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          width: 62,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isInterior
                                ? const Color(0xFF9D9D9D)
                                : const Color(0xFF5C636B),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Comments',
                          style: GoogleFonts.manrope(
                            color: titleColor,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: localComments.isEmpty
                              ? Center(
                                  child: Text(
                                    'No comments yet',
                                    style: GoogleFonts.manrope(
                                      color: mutedColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              : Builder(
                                  builder: (_) {
                                    final commentThreads = _buildCommentThreads(
                                      localComments,
                                    );
                                    return ListView.separated(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8,
                                      ),
                                      itemCount: commentThreads.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 14),
                                      itemBuilder: (_, index) {
                                        final thread = commentThreads[index];
                                        final comment = thread.parent;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildCommentTile(
                                              comment: comment,
                                              isInterior: isInterior,
                                              titleColor: titleColor,
                                              bodyColor: bodyColor,
                                              mutedColor: mutedColor,
                                              messageText: comment.text,
                                              onReply: () {
                                                final name = comment.userName
                                                    .trim();
                                                if (name.isEmpty) return;
                                                setState(() {
                                                  replyToName = name;
                                                  textController.text =
                                                      '@$name ';
                                                  textController.selection =
                                                      TextSelection.collapsed(
                                                        offset: textController
                                                            .text
                                                            .length,
                                                      );
                                                });
                                                inputFocusNode.requestFocus();
                                              },
                                            ),
                                            if (thread.replies.isNotEmpty) ...[
                                              const SizedBox(height: 8),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 18,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                        12,
                                                        2,
                                                        0,
                                                        0,
                                                      ),
                                                  child: Column(
                                                    children: List.generate(
                                                      thread.replies.length,
                                                      (replyIndex) {
                                                        final reply = thread
                                                            .replies[replyIndex];
                                                        return Padding(
                                                          padding: EdgeInsets.only(
                                                            bottom:
                                                                replyIndex ==
                                                                    thread
                                                                            .replies
                                                                            .length -
                                                                        1
                                                                ? 0
                                                                : 10,
                                                          ),
                                                          child: _buildCommentTile(
                                                            comment:
                                                                reply.comment,
                                                            isInterior:
                                                                isInterior,
                                                            titleColor:
                                                                titleColor,
                                                            bodyColor:
                                                                bodyColor,
                                                            mutedColor:
                                                                mutedColor,
                                                            messageText: reply
                                                                .displayText,
                                                            onReply: () {
                                                              final name = reply
                                                                  .comment
                                                                  .userName
                                                                  .trim();
                                                              if (name
                                                                  .isEmpty) {
                                                                return;
                                                              }
                                                              setState(() {
                                                                replyToName =
                                                                    name;
                                                                textController
                                                                        .text =
                                                                    '@$name ';
                                                                textController
                                                                        .selection =
                                                                    TextSelection.collapsed(
                                                                      offset: textController
                                                                          .text
                                                                          .length,
                                                                    );
                                                              });
                                                              inputFocusNode
                                                                  .requestFocus();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                        ),
                        if (replyToName != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isInterior
                                        ? const Color(0xFFB0A38D)
                                        : const Color(0xFF232A33),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'Replying to $replyToName',
                                    style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      replyToName = null;
                                      textController.clear();
                                    });
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: mutedColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isInterior
                                        ? const Color(0xFF7A787A)
                                        : const Color(0xFF2B2E37),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: TextField(
                                    controller: textController,
                                    focusNode: inputFocusNode,
                                    style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Write a Comment...',
                                      hintStyle: GoogleFonts.manrope(
                                        color: const Color(0xFFDBDBDB),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: isSending
                                    ? null
                                    : () async {
                                        final text = textController.text.trim();
                                        if (text.isEmpty) return;
                                        final payloadText =
                                            replyToName != null &&
                                                !text.startsWith('@')
                                            ? '@$replyToName $text'
                                            : text;
                                        final tempComment = UpdateCommentModel(
                                          id: 'local-${DateTime.now().microsecondsSinceEpoch}',
                                          updateId: updateId,
                                          text: payloadText,
                                          userName: currentUserName,
                                          userAvatar: currentUserAvatar,
                                          createdAt: DateTime.now(),
                                        );
                                        setState(() => isSending = true);
                                        setState(() {
                                          localComments.add(tempComment);
                                          textController.clear();
                                          replyToName = null;
                                        });
                                        final added = await controller
                                            .addComment(
                                              updateId: updateId,
                                              comment: payloadText,
                                            );
                                        setState(() {
                                          final tempIndex = localComments
                                              .indexWhere(
                                                (c) => c.id == tempComment.id,
                                              );
                                          if (tempIndex >= 0) {
                                            if (added != null) {
                                              localComments[tempIndex] = added;
                                            } else {
                                              localComments.removeAt(tempIndex);
                                            }
                                          }
                                        });
                                        setState(() => isSending = false);
                                      },
                                icon: Icon(
                                  Icons.send_rounded,
                                  size: 30,
                                  color: isInterior
                                      ? const Color(0xFF8E6500)
                                      : const Color(0xFFD09A2F),
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
          },
        );
      },
    );

    inputFocusNode.dispose();
    textController.dispose();
  }

  Widget _buildCommentTile({
    required UpdateCommentModel comment,
    required bool isInterior,
    required Color titleColor,
    required Color bodyColor,
    required Color mutedColor,
    required String messageText,
    required VoidCallback onReply,
  }) {
    final avatarUrl = comment.userAvatar;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isInterior
              ? const Color(0xFFC3BEB4)
              : const Color(0xFF2D3238),
          backgroundImage: avatarUrl != null && avatarUrl.trim().isNotEmpty
              ? NetworkImage(avatarUrl.trim())
              : null,
          child: avatarUrl == null || avatarUrl.trim().isEmpty
              ? Icon(
                  Icons.person_rounded,
                  size: 18,
                  color: isInterior
                      ? const Color(0xFF6A6358)
                      : const Color(0xFFD0D0D0),
                )
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      comment.userName,
                      style: GoogleFonts.manrope(
                        color: titleColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    _timeLabel(comment.createdAt),
                    style: GoogleFonts.manrope(
                      color: mutedColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                messageText,
                style: GoogleFonts.manrope(
                  color: bodyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onReply,
                child: Text(
                  'Reply',
                  style: GoogleFonts.manrope(
                    color: mutedColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<_CommentThread> _buildCommentThreads(List<UpdateCommentModel> comments) {
    final threads = <_CommentThread>[];

    for (final comment in comments) {
      final targetName = _extractReplyTargetName(
        comment.text,
        threads.map((thread) => thread.parent.userName).toList(),
      );

      if (targetName == null) {
        threads.add(_CommentThread(parent: comment, replies: []));
        continue;
      }

      final parentIndex = threads.lastIndexWhere(
        (thread) =>
            thread.parent.userName.trim().toLowerCase() ==
            targetName.trim().toLowerCase(),
      );

      if (parentIndex < 0) {
        threads.add(_CommentThread(parent: comment, replies: []));
        continue;
      }

      final replyText = _stripReplyPrefix(comment.text, targetName);
      threads[parentIndex].replies.add(
        _ThreadedReply(comment: comment, displayText: replyText),
      );
    }

    return threads;
  }

  String? _extractReplyTargetName(String message, List<String> candidateNames) {
    final trimmedMessage = message.trimLeft();
    if (!trimmedMessage.startsWith('@')) return null;

    String? bestMatch;
    var bestLength = -1;
    for (final name in candidateNames) {
      final trimmedName = name.trim();
      if (trimmedName.isEmpty) continue;
      final tag = '@$trimmedName ';
      if (trimmedMessage.toLowerCase().startsWith(tag.toLowerCase()) &&
          tag.length > bestLength) {
        bestMatch = trimmedName;
        bestLength = tag.length;
      }
    }
    return bestMatch;
  }

  String _stripReplyPrefix(String message, String targetName) {
    final trimmed = message.trimLeft();
    final prefix = '@${targetName.trim()} ';
    if (!trimmed.toLowerCase().startsWith(prefix.toLowerCase())) {
      return message;
    }
    final stripped = trimmed.substring(prefix.length).trimLeft();
    return stripped.isEmpty ? message : stripped;
  }

  Future<void> _shareUpdate({
    required BuildContext context,
    required UpdateController controller,
    required UpdateModel item,
  }) async {
    await controller.shareUpdate(item);

    if (!context.mounted) return;

    final lines = <String>[
      item.title.trim().isEmpty ? 'Project Update' : item.title.trim(),
      if (item.description.trim().isNotEmpty) item.description.trim(),
      if (item.thumbnailUrl?.trim().isNotEmpty ?? false)
        item.thumbnailUrl!.trim(),
    ];
    final shareText = lines.join('\n');
    final shareSubject = item.title.trim().isEmpty
        ? 'Project Update'
        : item.title.trim();

    try {
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(
        shareText,
        subject: shareSubject,
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      );
    } on MissingPluginException {
      if (!context.mounted) return;
      final handled = await _shareViaNativeChannel(
        shareText: shareText,
        subject: shareSubject,
      );
      if (!handled && context.mounted) {
        await _showShareFallbackSheet(context: context, shareText: shareText);
      }
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: shareText));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Share unavailable (${e.runtimeType}). Copied to clipboard.',
          ),
        ),
      );
    }
  }

  Future<bool> _shareViaNativeChannel({
    required String shareText,
    required String subject,
  }) async {
    try {
      final result = await _nativeShareChannel.invokeMethod<bool>('shareText', {
        'text': shareText,
        'subject': subject,
      });
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _showShareFallbackSheet({
    required BuildContext context,
    required String shareText,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF23222D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Native share is unavailable on this build. You can copy the text now.',
                  style: GoogleFonts.manrope(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: shareText));
                      if (!sheetContext.mounted) return;
                      Navigator.of(sheetContext).pop();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Share text copied to clipboard'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAF8C6A),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Copy Share Text',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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

class _CommentThread {
  final UpdateCommentModel parent;
  final List<_ThreadedReply> replies;

  const _CommentThread({required this.parent, required this.replies});
}

class _ThreadedReply {
  final UpdateCommentModel comment;
  final String displayText;

  const _ThreadedReply({required this.comment, required this.displayText});
}
