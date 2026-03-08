import 'package:stephen_farmer/core/network/api_service/api_client.dart';
import 'package:stephen_farmer/core/network/api_service/api_endpoints.dart';

import '../../domain/entities/task_project_entity.dart';
import '../../domain/repository/task_repository.dart';
import '../model/task_project_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({required ApiClient apiClient, this.useMockData = true})
    : _apiClient = apiClient;

  final ApiClient _apiClient;
  final bool useMockData;

  @override
  Future<List<TaskProjectEntity>> fetchTaskProjects() async {
    if (useMockData) {
      return TaskProjectModel.dummyData;
    }

    try {
      final response = await _apiClient.get(TaskEndpoints.getTasks);
      final rows = _extractRows(response.data);
      return rows.map(TaskProjectModel.fromJson).toList();
    } catch (e) {
      throw Exception('Failed to fetch task projects: $e');
    }
  }

  List<Map<String, dynamic>> _extractRows(dynamic payload) {
    dynamic source = payload;

    if (source is Map<String, dynamic>) {
      source =
          source["data"] ??
          source["projects"] ??
          source["taskProjects"] ??
          source["items"] ??
          source["results"] ??
          source;

      if (source is Map<String, dynamic>) {
        source =
            source["taskProjects"] ??
            source["projects"] ??
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
