import '../entities/task_project_entity.dart';

abstract class TaskRepository {
  Future<List<TaskProjectEntity>> fetchTaskProjects();
}
