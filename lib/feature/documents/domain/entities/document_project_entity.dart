class DocumentCategoryEntity {
  final String title;
  final int fileCount;
  final String type;

  const DocumentCategoryEntity({
    required this.title,
    required this.fileCount,
    required this.type,
  });
}

class RecentDocumentEntity {
  final String title;
  final String category;
  final String dateLabel;

  const RecentDocumentEntity({
    required this.title,
    required this.category,
    required this.dateLabel,
  });
}

class DocumentProjectEntity {
  final String projectName;
  final String projectAddress;
  final String? thumbnailUrl;
  final List<DocumentCategoryEntity> categories;
  final List<RecentDocumentEntity> recentDocuments;

  const DocumentProjectEntity({
    required this.projectName,
    required this.projectAddress,
    this.thumbnailUrl,
    required this.categories,
    required this.recentDocuments,
  });
}
