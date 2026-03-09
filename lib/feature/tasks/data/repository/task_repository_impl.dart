import '../../domain/entities/task_project_entity.dart';
import '../../domain/repository/task_repository.dart';
import '../model/task_project_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl();

  @override
  Future<List<TaskProjectEntity>> fetchTaskProjects() async {
    return TaskProjectModel.dummyData;
  }
}
