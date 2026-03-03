import '../../../../core/network/api_service/api_client.dart';
import '../../../../core/network/api_service/api_endpoints.dart';
import '../../data/model/update_model.dart';

class UpdateUseCase {
  Future<List<UpdateModel>> fetchUpdates(ApiClient apiClient) async {
    final response = await apiClient.get(UpdateEndpoints.getUpdates);
    final rawItems = extractUpdateList(response.data);
    return rawItems.map(UpdateModel.fromJson).toList();
  }

  List<Map<String, dynamic>> extractUpdateList(dynamic payload) {
    dynamic source = payload;

    if (source is Map<String, dynamic>) {
      source = source["data"] ??
          source["updates"] ??
          source["items"] ??
          source["results"] ??
          source;

      if (source is Map<String, dynamic>) {
        source = source["updates"] ??
            source["items"] ??
            source["results"] ??
            source["data"] ??
            [];
      }
    }

    if (source is List) {
      return source.whereType<Map<String, dynamic>>().toList();
    }

    return <Map<String, dynamic>>[];
  }

  List<String> buildCategoryFilters(List<UpdateModel> updates) {
    final uniqueCategories = <String>[];
    for (final item in updates) {
      final category = item.category.trim();
      if (category.isEmpty) continue;

      final exists = uniqueCategories.any(
        (e) => e.toLowerCase() == category.toLowerCase(),
      );
      if (!exists) {
        uniqueCategories.add(category);
      }
    }

    if (uniqueCategories.length > 1) {
      return ["All", ...uniqueCategories];
    }
    return uniqueCategories;
  }

  String resolveSelectedCategory({
    required List<String> categoryFilters,
    required String currentSelected,
  }) {
    if (categoryFilters.isEmpty) {
      return "All";
    }

    final index = categoryFilters.indexWhere(
      (e) => e.toLowerCase() == currentSelected.toLowerCase(),
    );
    if (index >= 0) {
      return categoryFilters[index];
    }
    return categoryFilters.first;
  }

  List<UpdateModel> filterUpdates({
    required List<UpdateModel> updates,
    required String selectedCategory,
  }) {
    if (selectedCategory.toLowerCase() == "all") {
      return updates;
    }

    final selected = selectedCategory.trim().toLowerCase();
    return updates
        .where((e) => e.category.trim().toLowerCase() == selected)
        .toList();
  }

  bool shouldShowCategoryDropdown(List<String> categoryFilters) {
    return categoryFilters.length > 1;
  }
}
