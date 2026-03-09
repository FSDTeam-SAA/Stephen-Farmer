import 'package:get/get.dart';

import '../../domain/entities/task_project_entity.dart';
import '../../domain/usecase/get_task_projects_usecase.dart';

class TaskController extends GetxController {
  TaskController({
    GetTaskProjectsUseCase? getProjectsUseCase,
  }) : _getProjectsUseCase = getProjectsUseCase ?? Get.find<GetTaskProjectsUseCase>();

  final GetTaskProjectsUseCase _getProjectsUseCase;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<TaskProjectEntity> projects = <TaskProjectEntity>[].obs;
  final RxInt selectedProjectIndex = 0.obs;
  final RxBool isProjectMenuOpen = false.obs;
  final RxInt managerPhaseTab = 0.obs;
  final RxInt selectedManagerTaskIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    refreshProjects();
  }

  TaskProjectEntity? get selectedProject {
    if (projects.isEmpty) return null;
    return projects[_safeIndex];
  }

  int get _safeIndex {
    if (projects.isEmpty) return 0;
    final current = selectedProjectIndex.value;
    if (current < 0) return 0;
    if (current >= projects.length) return projects.length - 1;
    return current;
  }

  Future<void> refreshProjects() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await _getProjectsUseCase.call();
      projects.assignAll(data);
      _normalizeState();
    } catch (_) {
      errorMessage.value = 'Failed to load task data. Please try again.';
      projects.clear();
      _normalizeState();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleProjectMenu() {
    if (projects.length <= 1) return;
    isProjectMenuOpen.value = !isProjectMenuOpen.value;
  }

  void selectProject(int index) {
    if (index < 0 || index >= projects.length) return;
    selectedProjectIndex.value = index;
    isProjectMenuOpen.value = false;
    managerPhaseTab.value = 0;
    selectedManagerTaskIndex.value = -1;
  }

  void setManagerPhaseTab(int index) {
    if (index < 0 || index > 1) return;
    managerPhaseTab.value = index;
    selectedManagerTaskIndex.value = -1;
  }

  void selectManagerTask(int index) {
    selectedManagerTaskIndex.value = index;
  }

  void _normalizeState() {
    selectedProjectIndex.value = _safeIndex;
    selectedManagerTaskIndex.value = -1;
    if (projects.length <= 1) {
      isProjectMenuOpen.value = false;
    }
  }
}
