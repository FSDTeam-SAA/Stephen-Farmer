import 'package:get/get.dart';
import '../../domain/entities/progress_entity.dart';
import '../../domain/usecase/get_progress_projects_usecase.dart';

class ProgressController extends GetxController {
  ProgressController({
    GetProgressProjectsUseCase? getProjectsUseCase,
  }) : _getProjectsUseCase = getProjectsUseCase ?? Get.find<GetProgressProjectsUseCase>();

  final GetProgressProjectsUseCase _getProjectsUseCase;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ProjectProgressEntity> projects = <ProjectProgressEntity>[].obs;
  final RxInt selectedProjectIndex = 0.obs;
  final RxBool isProjectMenuOpen = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshProjects();
  }

  bool get hasProjects => projects.isNotEmpty;

  bool get shouldShowProjectDropdown => projects.length > 1;

  ProjectProgressEntity? get selectedProject {
    if (!hasProjects) return null;
    final int safeIndex = _safeSelectedIndex();
    return projects[safeIndex];
  }

  Future<void> refreshProjects() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _getProjectsUseCase.call();
      projects.assignAll(result);
      _normalizeSelectedProject();
    } catch (_) {
      errorMessage.value = 'Failed to load progress data. Please try again.';
      projects.clear();
      _normalizeSelectedProject();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleProjectMenu() {
    if (!shouldShowProjectDropdown) return;
    isProjectMenuOpen.value = !isProjectMenuOpen.value;
  }

  void selectProject(int index) {
    if (index < 0 || index >= projects.length) return;
    selectedProjectIndex.value = index;
    isProjectMenuOpen.value = false;
  }

  int _safeSelectedIndex() {
    if (!hasProjects) return 0;
    final int index = selectedProjectIndex.value;
    if (index < 0) return 0;
    if (index >= projects.length) return projects.length - 1;
    return index;
  }

  void _normalizeSelectedProject() {
    selectedProjectIndex.value = _safeSelectedIndex();
    if (!shouldShowProjectDropdown) {
      isProjectMenuOpen.value = false;
    }
  }
}
