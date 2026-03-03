class ProgressTaskEntity {
  final String title;
  final String status;
  final int progressPercent;

  const ProgressTaskEntity({
    required this.title,
    required this.status,
    required this.progressPercent,
  });
}

class ProjectProgressEntity {
  final String name;
  final String address;
  final String heroImageUrl;
  final String? thumbnailUrl;
  final int overallCompletion;
  final int dayCurrent;
  final int dayTotal;
  final int tasksCompleted;
  final int tasksTotal;
  final int photosTotal;
  final String startedDate;
  final String handoverDate;
  final List<ProgressTaskEntity> tasks;

  const ProjectProgressEntity({
    required this.name,
    required this.address,
    required this.heroImageUrl,
    this.thumbnailUrl,
    required this.overallCompletion,
    required this.dayCurrent,
    required this.dayTotal,
    required this.tasksCompleted,
    required this.tasksTotal,
    required this.photosTotal,
    required this.startedDate,
    required this.handoverDate,
    required this.tasks,
  });
}
