import '../../domain/entities/progress_entity.dart';

class ProgressTaskModel extends ProgressTaskEntity {
  const ProgressTaskModel({
    required super.title,
    required super.status,
    required super.progressPercent,
  });

  factory ProgressTaskModel.fromJson(Map<String, dynamic> json) {
    return ProgressTaskModel(
      title: _readFirstString(json, ["title", "name", "task"], fallback: "Untitled Task"),
      status: _readFirstString(json, ["status", "state"], fallback: "In Progress"),
      progressPercent: _readFirstInt(json, ["progressPercent", "progress", "completion"], fallback: 0),
    );
  }
}

class ProjectProgressModel extends ProjectProgressEntity {
  const ProjectProgressModel({
    required super.name,
    required super.address,
    required super.heroImageUrl,
    super.thumbnailUrl,
    required super.overallCompletion,
    required super.dayCurrent,
    required super.dayTotal,
    required super.tasksCompleted,
    required super.tasksTotal,
    required super.photosTotal,
    required super.startedDate,
    required super.handoverDate,
    required super.tasks,
  });

  factory ProjectProgressModel.fromJson(Map<String, dynamic> json) {
    final taskPayload = json["tasks"] ?? json["milestones"] ?? json["items"];
    final taskList = _extractTaskList(taskPayload);

    return ProjectProgressModel(
      name: _readFirstString(json, ["name", "title", "projectName"], fallback: "Untitled Project"),
      address: _readFirstString(json, ["address", "location"], fallback: "N/A"),
      heroImageUrl: _readFirstString(json, ["heroImageUrl", "coverImage", "imageUrl", "image"], fallback: ""),
      thumbnailUrl: _readFirstString(json, ["thumbnailUrl", "thumbnail", "thumb"]).isEmpty
          ? null
          : _readFirstString(json, ["thumbnailUrl", "thumbnail", "thumb"]),
      overallCompletion: _readFirstInt(json, ["overallCompletion", "progressPercent", "completion"], fallback: 0),
      dayCurrent: _readFirstInt(json, ["dayCurrent", "dayProgress", "elapsedDays"], fallback: 0),
      dayTotal: _readFirstInt(json, ["dayTotal", "totalDays"], fallback: 0),
      tasksCompleted: _readFirstInt(json, ["tasksCompleted", "completedTasks"], fallback: 0),
      tasksTotal: _readFirstInt(json, ["tasksTotal", "totalTasks"], fallback: 0),
      photosTotal: _readFirstInt(json, ["photosTotal", "totalPhotos"], fallback: 0),
      startedDate: _readFirstString(json, ["startedDate", "startDate"], fallback: "N/A"),
      handoverDate: _readFirstString(json, ["handoverDate", "estHandoverDate"], fallback: "N/A"),
      tasks: taskList,
    );
  }

  static const List<ProjectProgressModel> dummyData = [
    ProjectProgressModel(
      name: 'Villa Horizon Renovation',
      address: '42 Harbor View Drive, Apt 12B',
      heroImageUrl:
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=1200&auto=format&fit=crop',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=400&auto=format&fit=crop',
      overallCompletion: 68,
      dayCurrent: 18,
      dayTotal: 30,
      tasksCompleted: 24,
      tasksTotal: 48,
      photosTotal: 124,
      startedDate: 'Jan 5',
      handoverDate: 'February 5',
      tasks: [
        ProgressTaskModel(
          title: 'Demolition & Strip-out',
          status: 'Completed',
          progressPercent: 100,
        ),
        ProgressTaskModel(
          title: 'Structural Works',
          status: 'In Progress',
          progressPercent: 72,
        ),
        ProgressTaskModel(
          title: 'Electrical Rough-in',
          status: 'In Progress',
          progressPercent: 58,
        ),
        ProgressTaskModel(
          title: 'Plumbing Lines',
          status: 'In Progress',
          progressPercent: 47,
        ),
      ],
    ),
    ProjectProgressModel(
      name: 'Riverside Apartment Upgrade',
      address: '15 Lakefront Avenue, Unit 8A',
      heroImageUrl:
          'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?w=1200&auto=format&fit=crop',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1616594039964-3f74d7c6a99c?w=400&auto=format&fit=crop',
      overallCompletion: 52,
      dayCurrent: 14,
      dayTotal: 28,
      tasksCompleted: 19,
      tasksTotal: 40,
      photosTotal: 96,
      startedDate: 'Jan 12',
      handoverDate: 'February 20',
      tasks: [
        ProgressTaskModel(
          title: 'Flooring Demolition',
          status: 'Completed',
          progressPercent: 100,
        ),
        ProgressTaskModel(
          title: 'Wall Framing',
          status: 'In Progress',
          progressPercent: 63,
        ),
        ProgressTaskModel(
          title: 'Ceiling Prep',
          status: 'In Progress',
          progressPercent: 39,
        ),
      ],
    ),
  ];
}

List<ProgressTaskModel> _extractTaskList(dynamic payload) {
  if (payload is List) {
    return payload.whereType<Map<String, dynamic>>().map(ProgressTaskModel.fromJson).toList();
  }
  return <ProgressTaskModel>[];
}

String _readFirstString(
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

int _readFirstInt(
  Map<String, dynamic> json,
  List<String> keys, {
  int fallback = 0,
}) {
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
