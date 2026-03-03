import 'package:stephen_farmer/core/network/api_service/api_client.dart';
import 'package:stephen_farmer/core/network/api_service/api_endpoints.dart';

import '../../domain/entities/document_project_entity.dart';
import '../../domain/repository/document_repository.dart';
import '../model/document_project_model.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  DocumentRepositoryImpl({
    required ApiClient apiClient,
    this.useMockData = true,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final bool useMockData;

  @override
  Future<List<DocumentProjectEntity>> fetchProjects() async {
    if (useMockData) {
      return DocumentProjectModel.dummyData;
    }

    try {
      final response = await _apiClient.get(DocumentEndpoints.getProjects);
      final rows = _extractRows(response.data);
      return rows.map(DocumentProjectModel.fromJson).toList();
    } catch (e) {
      throw Exception('Failed to fetch document projects: $e');
    }
  }

  List<Map<String, dynamic>> _extractRows(dynamic payload) {
    dynamic source = payload;

    if (source is Map<String, dynamic>) {
      source = source["data"] ??
          source["projects"] ??
          source["documentProjects"] ??
          source["items"] ??
          source["results"] ??
          source;

      if (source is Map<String, dynamic>) {
        source = source["documentProjects"] ??
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
