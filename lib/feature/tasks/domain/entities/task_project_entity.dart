class TaskItemEntity {
  final String title;
  final String subtitle;
  final String priority;
  final String phaseStatus; // expected: active / finished

  const TaskItemEntity({
    required this.title,
    required this.subtitle,
    required this.priority,
    this.phaseStatus = '',
  });

  String get normalizedPhaseStatus => phaseStatus.trim().toLowerCase();

  bool get isFinished {
    final value = normalizedPhaseStatus;
    return value == 'finished' || value == 'complete' || value == 'completed' || value == 'done';
  }

  bool get isActive {
    final value = normalizedPhaseStatus;
    return value == 'active' || value == 'pending' || value == 'in_progress' || value == 'in progress' || value == 'ongoing';
  }
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
