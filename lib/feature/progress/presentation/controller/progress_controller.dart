import 'package:get/get.dart';
import 'package:stephen_farmer/core/network/api_service/api_client.dart';

import '../../data/repository/progress_repository_impl.dart';
import '../../domain/entities/progress_entity.dart';
import '../../domain/repository/progress_repository.dart';
import '../../domain/usecase/get_progress_projects_usecase.dart';

class ProgressController extends GetxController {
  ProgressController({
    GetProgressProjectsUseCase? getProjectsUseCase,
    ProgressRepository? repository,
    ApiClient? apiClient,
  }) : _getProjectsUseCase = getProjectsUseCase ??
            GetProgressProjectsUseCase(
              repository: repository ??
                  ProgressRepositoryImpl(
                    apiClient: apiClient ?? _findApiClient(),
                    useMockData: true,
                  ),
            );

  final GetProgressProjectsUseCase _getProjectsUseCase;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ProjectProgressEntity> projects = <ProjectProgressEntity>[].obs;
  final RxInt selectedProjectIndex = 0.obs;
  final RxBool isProjectMenuOpen = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  bool get hasProjects => projects.isNotEmpty;

  bool get shouldShowProjectDropdown => projects.length > 1;

  ProjectProgressEntity? get selectedProject {
    if (!hasProjects) return null;
    final int safeIndex = _safeSelectedIndex();
    return projects[safeIndex];
  }

  Future<void> fetchProjects() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _getProjectsUseCase.call();
      projects.assignAll(result);
      _normalizeSelectedProject();
    } catch (e) {
      errorMessage.value = e.toString();
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

ApiClient? _findApiClient() {
  if (Get.isRegistered<ApiClient>()) {
    return Get.find<ApiClient>();
  }
  return null;
}
