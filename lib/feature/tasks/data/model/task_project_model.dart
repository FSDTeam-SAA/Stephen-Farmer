import '../../domain/entities/task_project_entity.dart';
import '../../../../core/utils/images.dart';

class TaskItemModel extends TaskItemEntity {
  const TaskItemModel({
    required super.title,
    required super.subtitle,
    required super.priority,
    super.phaseStatus,
  });

  factory TaskItemModel.fromJson(Map<String, dynamic> json) {
    // API compatibility:
    // backend can send phase status as phaseStatus/status/taskStatus.
    return TaskItemModel(
      title: _readString(json, ["title", "name"], fallback: "Untitled task"),
      subtitle: _readString(json, ["subtitle", "description"], fallback: ""),
      priority: _readString(json, ["priority", "level"], fallback: "Medium"),
      phaseStatus: _readString(json, [
        "phaseStatus",
        "status",
        "taskStatus",
      ], fallback: ""),
    );
  }
}

class TaskSectionModel extends TaskSectionEntity {
  const TaskSectionModel({
    required super.title,
    required super.pendingCount,
    required super.items,
  });

  factory TaskSectionModel.fromJson(Map<String, dynamic> json) {
    final rows = json["items"];
    final items = rows is List
        ? rows
              .whereType<Map<String, dynamic>>()
              .map(TaskItemModel.fromJson)
              .toList()
        : <TaskItemModel>[];

    return TaskSectionModel(
      title: _readString(json, ["title", "name"], fallback: "Tasks"),
      pendingCount: _readInt(json, ["pendingCount", "pending"], fallback: 0),
      items: items,
    );
  }
}

class TaskProjectModel extends TaskProjectEntity {
  const TaskProjectModel({
    required super.projectName,
    required super.projectAddress,
    super.thumbnailUrl,
    required super.actionsNeededCount,
    required super.actionsNeededMessage,
    required super.sections,
  });

  factory TaskProjectModel.fromJson(Map<String, dynamic> json) {
    final rows = json["sections"] ?? json["taskSections"] ?? json["groups"];
    final sections = rows is List
        ? rows
              .whereType<Map<String, dynamic>>()
              .map(TaskSectionModel.fromJson)
              .toList()
        : <TaskSectionModel>[];

    return TaskProjectModel(
      projectName: _readString(json, [
        "projectName",
        "name",
        "title",
      ], fallback: "Untitled Project"),
      projectAddress: _readString(json, [
        "projectAddress",
        "address",
        "location",
      ], fallback: "N/A"),
      thumbnailUrl:
          _readString(json, ["thumbnailUrl", "thumbnail", "imageUrl"]).isEmpty
          ? null
          : _readString(json, ["thumbnailUrl", "thumbnail", "imageUrl"]),
      actionsNeededCount: _readInt(json, [
        "actionsNeededCount",
        "actionsCount",
      ], fallback: 0),
      actionsNeededMessage: _readString(json, [
        "actionsNeededMessage",
        "actionsMessage",
      ], fallback: "Your decisions are required to keep progress on track"),
      sections: sections,
    );
  }

  static const List<TaskProjectModel> dummyData = [
    TaskProjectModel(
      projectName: "Riverside Apartment Renovation",
      projectAddress: "42 Harbor View Drive, Apt 12B",
      thumbnailUrl: AssetsImages.actionsNeeded,
      actionsNeededCount: 2,
      actionsNeededMessage:
          "Your decisions are required to keep progress on track",
      sections: [
        TaskSectionModel(
          title: "Your Actions",
          pendingCount: 2,
          items: [
            TaskItemModel(
              title: "Approve bathroom tile layout",
              subtitle: "Review the update tile...",
              priority: "HIGH",
              phaseStatus: "active",
            ),
            TaskItemModel(
              title: "Select Door handles",
              subtitle: "Review the update tile...",
              priority: "Medium",
              phaseStatus: "finished",
            ),
          ],
        ),
        TaskSectionModel(
          title: "Designer Tasks",
          pendingCount: 2,
          items: [
            TaskItemModel(
              title: "Finalize furniture layout",
              subtitle: "Complete 3D renders for client...",
              priority: "HIGH",
              phaseStatus: "active",
            ),
            TaskItemModel(
              title: "Order window treatments",
              subtitle: "Review the update tile...",
              priority: "Medium",
              phaseStatus: "active",
            ),
          ],
        ),
      ],
    ),

    TaskProjectModel(
      projectName: "Cityline Duplex Build",
      projectAddress: "15 Lakefront Ave, Unit 12",
      thumbnailUrl:
          "https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?w=400&auto=format&fit=crop",
      actionsNeededCount: 1,
      actionsNeededMessage: "One approval is pending to continue execution.",
      sections: [
        TaskSectionModel(
          title: "Your Actions",
          pendingCount: 1,
          items: [
            TaskItemModel(
              title: "Confirm kitchen island material",
              subtitle: "Approve the final finish option...",
              priority: "HIGH",
              phaseStatus: "active",
            ),
          ],
        ),
        TaskSectionModel(
          title: "Designer Tasks",
          pendingCount: 1,
          items: [
            TaskItemModel(
              title: "Lighting mockup revisions",
              subtitle: "Update pendant placement render...",
              priority: "Medium",
              phaseStatus: "finished",
            ),
          ],
        ),
      ],
    ),
  ];
}

String _readString(
  Map<String, dynamic> json,
  List<String> keys, {
  String fallback = "",
}) {
  for (final key in keys) {
    final value = json[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString().trim();
    }
  }
  return fallback;
}

int _readInt(Map<String, dynamic> json, List<String> keys, {int fallback = 0}) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      final parsed = int.tryParse(value.trim());
      if (parsed != null) return parsed;
    }
  }
  return fallback;
}
