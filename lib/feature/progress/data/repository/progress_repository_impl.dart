import 'package:stephen_farmer/core/network/api_service/api_client.dart';

import '../../domain/entities/progress_entity.dart';
import '../../domain/repository/progress_repository.dart';
import '../model/progress_model.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl({
    ApiClient? apiClient,
    this.useMockData = true,
  }) : _apiClient = apiClient;

  final ApiClient? _apiClient;
  final bool useMockData;

  static const String _projectsEndpoint = "/progress/projects";

  @override
  Future<List<ProjectProgressEntity>> fetchProjects() async {
    if (useMockData || _apiClient == null) {
      return ProjectProgressModel.dummyData;
    }

    try {
      final response = await _apiClient.get(_projectsEndpoint);
      final rows = _extractProjectRows(response.data);
      if (rows.isEmpty) {
        return ProjectProgressModel.dummyData;
      }
      return rows.map(ProjectProgressModel.fromJson).toList();
    } catch (_) {
      // Keep UI usable while endpoint integration is incomplete.
      return ProjectProgressModel.dummyData;
    }
  }

  List<Map<String, dynamic>> _extractProjectRows(dynamic payload) {
    dynamic source = payload;

    if (source is Map<String, dynamic>) {
      source = source["data"] ??
          source["projects"] ??
          source["items"] ??
          source["results"] ??
          source;

      if (source is Map<String, dynamic>) {
        source = source["projects"] ??
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
}
