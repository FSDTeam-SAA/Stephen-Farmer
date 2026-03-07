import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stephen_farmer/core/common/widgets/category_dropdown_widget.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/core/utils/images.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';

import '../../../../core/colors/app_color.dart';
import '../controller/progress_controller.dart';
import 'update_progrees_screen_view.dart';
import '../widgets/progress_overview_card.dart';
import '../widgets/progress_stat_card.dart';
import '../widgets/progress_task_item_card.dart';

class ProgressScreenView extends GetView<ProgressController> {
  const ProgressScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final authController = Get.find<LoginController>();
      final project = controller.selectedProject;
      final role = authController.role.value;
      final bool isManager = authController.normalizedRoleKey == 'manager';
      final bool isInterior = RoleBgColor.isInterior(role);
      final Color titleColor = isInterior ? const Color(0xFF1D1D1D) : Colors.white;

      return Scaffold(
        backgroundColor: RoleBgColor.scaffoldColor(role),
        body: SafeArea(
          child: Container(
            decoration: RoleBgColor.decoration(role),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Project',
                    style: TextStyle(color: titleColor, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  if (controller.isLoading.value && !controller.hasProjects)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else if (project == null)
                    Expanded(
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                          decoration: BoxDecoration(
                            color: isInterior ? const Color(0xFFD5D2CA) : const Color(0xFF111A1E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isInterior ? const Color(0xFF77716A) : const Color(0xFFB9A77D)),
                          ),
                          child: Text(
                            controller.errorMessage.value.isEmpty ? 'No progress data available' : controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: isInterior ? const Color(0xFF1D1D1D) : Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  else ...[
                    CategoryDropdownWidget(
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
                    const SizedBox(height: 12),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: controller.refreshProjects,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: [
                            ProgressOverviewCard(project: project),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                ProgressStatCard(
                                  icon: Icons.calendar_month_rounded,
                                  label: 'Day',
                                  value: '${project.dayCurrent}/${project.dayTotal}',
                                ),
                                const SizedBox(width: 8),
                                ProgressStatCard(
                                  icon: Icons.task_alt_rounded,
                                  label: 'Tasks',
                                  value: '${project.tasksCompleted}/${project.tasksTotal}',
                                ),
                                const SizedBox(width: 8),
                                ProgressStatCard(icon: Icons.image_rounded, label: 'Photos', value: '${project.photosTotal}'),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    'Progress',
                                    style: TextStyle(color: titleColor, fontSize: 24, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                if (isManager)
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => const UpdateProgreesScreenView());
                                    },
                                    child: Icon(Icons.add_circle_outline, size: 30, color: AppColor.appColor),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            ...project.tasks.map((task) => ProgressTaskItemCard(task: task)),
                            if (controller.errorMessage.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
                                child: Text(controller.errorMessage.value, style: const TextStyle(color: Color(0xFFFF7A7A), fontSize: 12)),
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
}
