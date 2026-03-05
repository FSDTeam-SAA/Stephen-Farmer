import 'package:get/get.dart';

import '../../../../core/network/api_service/api_client.dart';
import '../../data/model/update_model.dart';
import '../../domain/usecase/update_usecase.dart';

class UpdateController extends GetxController {
  UpdateController({ApiClient? apiClient, UpdateUseCase? useCase})
    : _apiClient = apiClient ?? Get.find<ApiClient>(),
      _useCase = useCase ?? UpdateUseCase();

  final ApiClient _apiClient;
  final UpdateUseCase _useCase;
  final RxString selectedCategory = "All".obs;
  final RxBool isCategoryMenuOpen = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<String> categoryFilters = <String>[].obs;
  final RxList<UpdateModel> updateList = <UpdateModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpdates();
  }

  bool get shouldShowCategoryDropdown =>
      _useCase.shouldShowCategoryDropdown(categoryFilters);

  List<UpdateModel> get filteredUpdates {
    return _useCase.filterUpdates(
      updates: updateList.toList(),
      selectedCategory: selectedCategory.value,
    );
  }

  Future<void> fetchUpdates() async {
    try {
      isLoading.value = true;
      final updates = await _useCase.fetchUpdates(_apiClient);
      updateList.assignAll(updates);
      _refreshCategoryFilters();
    } catch (_) {
      // Temporary fallback so UI stays usable while API integration is in progress.
      updateList.assignAll(UpdateModel.dummyData);
      _refreshCategoryFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void _refreshCategoryFilters() {
    final nextFilters = _useCase.buildCategoryFilters(updateList.toList());
    categoryFilters.assignAll(nextFilters);

    selectedCategory.value = _useCase.resolveSelectedCategory(
      categoryFilters: categoryFilters,
      currentSelected: selectedCategory.value,
    );

    if (!shouldShowCategoryDropdown) {
      isCategoryMenuOpen.value = false;
    }
  }

  void toggleCategoryMenu() {
    if (!shouldShowCategoryDropdown) return;
    isCategoryMenuOpen.value = !isCategoryMenuOpen.value;
  }

  void selectCategory(String value) {
    if (!categoryFilters.contains(value)) return;
    selectedCategory.value = value;
    isCategoryMenuOpen.value = false;
  }
}
