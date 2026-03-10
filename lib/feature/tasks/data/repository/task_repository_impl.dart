import 'package:dio/dio.dart';

import '../../../../core/network/api_service/api_client.dart';
import '../../../../core/network/api_service/api_endpoints.dart';
import '../../domain/entities/task_project_entity.dart';
import '../../domain/repository/task_repository.dart';
import '../model/task_project_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({required ApiClient apiClient, this.useMockData = false})
    : _apiClient = apiClient;

  final ApiClient _apiClient;
  final bool useMockData;

  @override
  Future<List<TaskProjectEntity>> fetchTaskProjects() async {
    if (useMockData) {
      return TaskProjectModel.dummyData;
    }

    final response = await _apiClient.get(TaskEndpoints.getTasks);
    final rows = _extractList(
      response.data,
      preferredKeys: const ['projects', 'tasks', 'items', 'results', 'data'],
    );

    if (rows.isEmpty) {
      return const <TaskProjectEntity>[];
    }

    if (_isTaskListPayload(rows)) {
      return _buildProjectsFromTaskRows(rows);
    }

    return rows.map(TaskProjectModel.fromJson).toList();
  }

  @override
  Future<List<TaskItemEntity>> fetchTasks({Map<String, dynamic>? query}) async {
    final response = await _apiClient.get(TaskEndpoints.getTasks, query: query);
    final rows = _extractList(
      response.data,
      preferredKeys: const ['tasks', 'items', 'data'],
    );
    return rows.map(TaskItemModel.fromJson).toList();
  }

  @override
  Future<TaskItemEntity> getTaskDetails(String taskId) async {
    final response = await _apiClient.get(TaskEndpoints.getTaskDetails(taskId));
    return TaskItemModel.fromJson(
      _extractMap(response.data, preferredKeys: const ['task', 'data']),
    );
  }

  @override
  Future<TaskItemEntity> createTask(Map<String, dynamic> payload) async {
    final response = await _apiClient.post(
      TaskEndpoints.createTask,
      data: payload,
    );
    return TaskItemModel.fromJson(
      _extractMap(response.data, preferredKeys: const ['task', 'data']),
    );
  }

  @override
  Future<TaskItemEntity> updateTaskByManager(
    String taskId,
    Map<String, dynamic> payload,
  ) async {
    final response = await _apiClient.patch(
      TaskEndpoints.updateTaskByManager(taskId),
      data: payload,
    );
    return TaskItemModel.fromJson(
      _extractMap(response.data, preferredKeys: const ['task', 'data']),
    );
  }

  @override
  Future<TaskItemEntity> resubmitTaskForApproval(
    String taskId, {
    Map<String, dynamic>? payload,
  }) async {
    final response = await _apiClient.patch(
      TaskEndpoints.resubmitTaskForApproval(taskId),
      data: payload ?? const <String, dynamic>{},
    );
    return TaskItemModel.fromJson(
      _extractMap(response.data, preferredKeys: const ['task', 'data']),
    );
  }

  @override
  Future<TaskItemEntity> approveTask(
    String taskId, {
    Map<String, dynamic>? payload,
  }) async {
    final response = await _apiClient.patch(
      TaskEndpoints.approveTask(taskId),
      data: payload ?? const <String, dynamic>{},
    );
    return TaskItemModel.fromJson(
      _extractMap(response.data, preferredKeys: const ['task', 'data']),
    );
  }

  @override
  Future<TaskItemEntity> rejectTask(
    String taskId, {
    Map<String, dynamic>? payload,
  }) async {
    final response = await _apiClient.patch(
      TaskEndpoints.rejectTask(taskId),
      data: payload ?? const <String, dynamic>{},
    );
    return TaskItemModel.fromJson(
      _extractMap(response.data, preferredKeys: const ['task', 'data']),
    );
  }

  @override
  Future<TaskItemEntity> updateTaskStatus(
    String taskId, {
    required Map<String, dynamic> payload,
  }) async {
    final response = await _apiClient.patch(
      TaskEndpoints.updateTaskStatus(taskId),
      data: payload,
    );
    return TaskItemModel.fromJson(
      _extractMap(response.data, preferredKeys: const ['task', 'data']),
    );
  }
}

bool _isTaskListPayload(List<Map<String, dynamic>> rows) {
  final first = rows.first;
  final hasProjectShape =
      first['sections'] is List ||
      first['taskSections'] is List ||
      first['groups'] is List;
  if (hasProjectShape) {
    return false;
  }

  return first.containsKey('title') ||
      first.containsKey('taskTitle') ||
      first.containsKey('priority') ||
      first.containsKey('status');
}

List<TaskProjectEntity> _buildProjectsFromTaskRows(
  List<Map<String, dynamic>> rows,
) {
  final grouped = <String, List<Map<String, dynamic>>>{};
  final projectMeta = <String, Map<String, dynamic>>{};

  for (final row in rows) {
    final project = _extractProjectMap(row);
    final projectId = _resolveProjectId(row, project);
    grouped.putIfAbsent(projectId, () => <Map<String, dynamic>>[]).add(row);
    projectMeta.putIfAbsent(projectId, () => project);
  }

  return grouped.entries.map((entry) {
    final projectId = entry.key;
    final taskRows = entry.value;
    final meta = projectMeta[projectId] ?? const <String, dynamic>{};

    final sectionRows = <String, List<Map<String, dynamic>>>{};
    for (final row in taskRows) {
      final title = _resolveSectionTitle(row);
      sectionRows.putIfAbsent(title, () => <Map<String, dynamic>>[]).add(row);
    }

    final sections = sectionRows.entries.map((sectionEntry) {
      final items = sectionEntry.value.map(TaskItemModel.fromJson).toList();
      final pendingCount = items.where((item) => !item.isFinished).length;
      return TaskSectionModel(
        title: sectionEntry.key,
        pendingCount: pendingCount,
        items: items,
      );
    }).toList();

    final actionsNeededCount = sections
        .expand((section) => section.items)
        .where((item) => item.needsApproval)
        .length;

    return TaskProjectModel(
      id: projectId == '__unassigned__' ? '' : projectId,
      projectName: _resolveProjectName(taskRows.first, meta),
      projectAddress: _resolveProjectAddress(taskRows.first, meta),
      thumbnailUrl: _resolveProjectThumbnail(taskRows.first, meta),
      actionsNeededCount: actionsNeededCount,
      actionsNeededMessage:
          'Your decisions are required to keep progress on track',
      sections: sections,
    );
  }).toList();
}

Map<String, dynamic> _extractProjectMap(Map<String, dynamic> row) {
  final project = row['project'];
  if (project is Map<String, dynamic>) return project;

  final projectInfo = row['projectInfo'];
  if (projectInfo is Map<String, dynamic>) return projectInfo;

  return const <String, dynamic>{};
}

String _resolveProjectId(
  Map<String, dynamic> row,
  Map<String, dynamic> project,
) {
  final fromProject = _firstNonEmpty(<dynamic>[
    project['_id'],
    project['id'],
    project['projectId'],
  ]);
  if (fromProject.isNotEmpty) return fromProject;

  final direct = row['project'];
  if (direct is String && direct.trim().isNotEmpty) return direct.trim();

  final fromRow = _firstNonEmpty(<dynamic>[
    row['projectId'],
    row['project_id'],
    row['_projectId'],
  ]);
  if (fromRow.isNotEmpty) return fromRow;

  return '__unassigned__';
}

String _resolveProjectName(
  Map<String, dynamic> row,
  Map<String, dynamic> project,
) {
  final value = _firstNonEmpty(<dynamic>[
    row['projectName'],
    row['project_name'],
    row['name'],
    project['projectName'],
    project['name'],
    project['title'],
  ]);
  return value.isEmpty ? 'Untitled Project' : value;
}

String _resolveProjectAddress(
  Map<String, dynamic> row,
  Map<String, dynamic> project,
) {
  final value = _firstNonEmpty(<dynamic>[
    row['projectAddress'],
    row['project_address'],
    row['address'],
    row['location'],
    project['projectAddress'],
    project['address'],
    project['location'],
  ]);
  return value.isEmpty ? 'N/A' : value;
}

String? _resolveProjectThumbnail(
  Map<String, dynamic> row,
  Map<String, dynamic> project,
) {
  final value = _firstNonEmpty(<dynamic>[
    row['thumbnailUrl'],
    row['thumbnail'],
    row['imageUrl'],
    row['image'],
    project['thumbnailUrl'],
    project['thumbnail'],
    project['imageUrl'],
    project['image'],
  ]);
  return value.isEmpty ? null : value;
}

String _resolveSectionTitle(Map<String, dynamic> row) {
  final value = _firstNonEmpty(<dynamic>[
    row['section'],
    row['sectionName'],
    row['group'],
    row['groupName'],
    row['category'],
    row['phase'],
    row['phaseName'],
  ]);
  return value.isEmpty ? 'Tasks' : value;
}

String _firstNonEmpty(List<dynamic> values) {
  for (final value in values) {
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }
  return '';
}

Map<String, dynamic> _extractMap(
  dynamic payload, {
  List<String> preferredKeys = const <String>[],
}) {
  if (payload is Map<String, dynamic>) {
    for (final key in preferredKeys) {
      final value = payload[key];
      if (value is Map<String, dynamic>) {
        return value;
      }
    }

    final data = payload['data'];
    if (data is Map<String, dynamic>) {
      for (final key in preferredKeys) {
        final nested = data[key];
        if (nested is Map<String, dynamic>) {
          return nested;
        }
      }
      return data;
    }

    return payload;
  }

  throw DioException(
    requestOptions: RequestOptions(path: ''),
    error: 'Invalid response payload',
  );
}

List<Map<String, dynamic>> _extractList(
  dynamic payload, {
  List<String> preferredKeys = const <String>[],
}) {
  if (payload is List) {
    return payload.whereType<Map<String, dynamic>>().toList();
  }

  if (payload is! Map<String, dynamic>) {
    return const <Map<String, dynamic>>[];
  }

  for (final key in preferredKeys) {
    final value = payload[key];
    if (value is List) {
      return value.whereType<Map<String, dynamic>>().toList();
    }
    if (value is Map<String, dynamic>) {
      final nested = _extractList(value, preferredKeys: preferredKeys);
      if (nested.isNotEmpty) {
        return nested;
      }
    }
  }

  final data = payload['data'];
  if (data is List) {
    return data.whereType<Map<String, dynamic>>().toList();
  }
  if (data is Map<String, dynamic>) {
    return _extractList(data, preferredKeys: preferredKeys);
  }

  return const <Map<String, dynamic>>[];
}
