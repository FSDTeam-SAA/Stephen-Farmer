import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/progress_controller.dart';
import '../widgets/progress_overview_card.dart';
import '../widgets/progress_project_dropdown_card.dart';
import '../widgets/progress_stat_card.dart';
import '../widgets/progress_task_item_card.dart';

class ProgressScreenView extends StatelessWidget {
  const ProgressScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProgressController controller = Get.put(ProgressController());

    return Obx(() {
      final project = controller.selectedProject;

      return Scaffold(
        backgroundColor: const Color(0xFF0B1419),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Active Project',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                if (controller.isLoading.value && !controller.hasProjects)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (project == null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111A1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB9A77D)),
                    ),
                    child: const Text(
                      'No progress data available',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                else ...[
                  ProgressProjectDropdownCard(
                    projects: controller.projects.toList(),
                    selectedProjectIndex: controller.selectedProjectIndex.value,
                    isMenuOpen: controller.isProjectMenuOpen.value,
                    onToggle: controller.toggleProjectMenu,
                    onSelect: controller.selectProject,
                  ),
                  const SizedBox(height: 12),
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
                      ProgressStatCard(
                        icon: Icons.image_rounded,
                        label: 'Photos',
                        value: '${project.photosTotal}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...project.tasks.map((task) => ProgressTaskItemCard(task: task)),
                ],
                if (controller.errorMessage.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
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
      );
    });
  }
}
