import '../entities/document_project_entity.dart';

abstract class DocumentRepository {
  Future<List<DocumentProjectEntity>> fetchProjects();
}
