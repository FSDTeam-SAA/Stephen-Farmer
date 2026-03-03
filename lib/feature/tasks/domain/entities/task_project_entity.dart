class TaskItemEntity {
  final String title;
  final String subtitle;
  final String priority;

  const TaskItemEntity({
    required this.title,
    required this.subtitle,
    required this.priority,
  });
}

class TaskSectionEntity {
  final String title;
  final int pendingCount;
  final List<TaskItemEntity> items;

  const TaskSectionEntity({
    required this.title,
    required this.pendingCount,
    required this.items,
  });
}

class TaskProjectEntity {
  final String projectName;
  final String projectAddress;
  final String? thumbnailUrl;
  final int actionsNeededCount;
  final String actionsNeededMessage;
  final List<TaskSectionEntity> sections;

  const TaskProjectEntity({
    required this.projectName,
    required this.projectAddress,
    this.thumbnailUrl,
    required this.actionsNeededCount,
    required this.actionsNeededMessage,
    required this.sections,
  });
}
