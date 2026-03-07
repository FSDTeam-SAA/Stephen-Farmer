import 'dart:io';

import '../entities/document_project_entity.dart';

abstract class DocumentRepository {
  Future<List<DocumentProjectEntity>> fetchProjects();
  Future<void> uploadDocument({
    required String projectId,
    required File document,
    String? title,
    String? category,
  });
}
