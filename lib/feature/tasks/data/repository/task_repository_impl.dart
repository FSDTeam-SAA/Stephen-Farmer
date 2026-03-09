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
      preferredKeys: const ['projects', 'items', 'tasks', 'data'],
    );

    if (rows.isEmpty) {
      return TaskProjectModel.dummyData;
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
