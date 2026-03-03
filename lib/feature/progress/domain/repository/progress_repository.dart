import '../entities/progress_entity.dart';

abstract class ProgressRepository {
  Future<List<ProjectProgressEntity>> fetchProjects();
}
