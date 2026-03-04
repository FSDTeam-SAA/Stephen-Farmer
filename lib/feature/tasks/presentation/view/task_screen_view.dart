import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';

import '../controller/task_controller.dart';
import '../widgets/task_action_attention_card.dart';
import '../widgets/task_action_item_card.dart';
import '../widgets/task_project_dropdown_card.dart';
import '../widgets/task_section_header_row.dart';

class TaskScreenView extends GetView<TaskController> {
  const TaskScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final project = controller.selectedProject;
      final role = Get.find<LoginController>().role.value;
      final isInterior = RoleBgColor.isInterior(role);

      return Scaffold(
        backgroundColor: RoleBgColor.scaffoldColor(role),
        body: SafeArea(
          child: Container(
            decoration: RoleBgColor.decoration(role),
            // color: isInterior ? null : const Color(0xFF0B1419),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Project',
                    style: TextStyle(
                      color: isInterior
                          ? const Color(0xFF1D1D1D)
                          : Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (controller.isLoading.value && project == null)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (project == null)
                    Expanded(
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: isInterior
                                ? const Color(0xFFD5D2CA)
                                : const Color(0xFF111A1E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isInterior
                                  ? const Color(0xFF77716A)
                                  : const Color(0xFFB9A77D),
                            ),
                          ),
                          child: Text(
                            controller.errorMessage.value.isEmpty
                                ? 'No task data available'
                                : controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isInterior
                                  ? const Color(0xFF2E2E2E)
                                  : Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    )
                  else ...[
                    TaskProjectDropdownCard(
                      projects: controller.projects,
                      selectedProjectIndex:
                          controller.selectedProjectIndex.value,
                      isMenuOpen: controller.isProjectMenuOpen.value,
                      onToggle: controller.toggleProjectMenu,
                      onSelect: controller.selectProject,
                    ),
                    const SizedBox(height: 10),
                    TaskActionAttentionCard(
                      count: project.actionsNeededCount,
                      message: project.actionsNeededMessage,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: controller.refreshProjects,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: [
                            for (final section in project.sections) ...[
                              TaskSectionHeaderRow(
                                title: section.title,
                                pendingCount: section.pendingCount,
                                showLeadingIcon:
                                    section.title.trim().toLowerCase() ==
                                    'your actions',
                              ),
                              const SizedBox(height: 8),
                              ...section.items.map(
                                (item) => TaskActionItemCard(item: item),
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (controller.errorMessage.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(
                                    color: Color(0xFF8C2323),
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
}
