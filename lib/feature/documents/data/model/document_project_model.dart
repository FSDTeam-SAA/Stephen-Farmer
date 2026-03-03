import '../../domain/entities/document_project_entity.dart';

class DocumentCategoryModel extends DocumentCategoryEntity {
  const DocumentCategoryModel({
    required super.title,
    required super.fileCount,
    required super.type,
  });

  factory DocumentCategoryModel.fromJson(Map<String, dynamic> json) {
    return DocumentCategoryModel(
      title: _readString(json, ["title", "name"], fallback: "Category"),
      fileCount: _readInt(json, ["fileCount", "count"], fallback: 0),
      type: _readString(json, ["type", "key"], fallback: "default"),
    );
  }
}

class RecentDocumentModel extends RecentDocumentEntity {
  const RecentDocumentModel({
    required super.title,
    required super.category,
    required super.dateLabel,
  });

  factory RecentDocumentModel.fromJson(Map<String, dynamic> json) {
    return RecentDocumentModel(
      title: _readString(json, ["title", "name"], fallback: "Untitled Document"),
      category: _readString(json, ["category", "type"], fallback: "General"),
      dateLabel: _readString(json, ["dateLabel", "date"], fallback: ""),
    );
  }
}

class DocumentProjectModel extends DocumentProjectEntity {
  const DocumentProjectModel({
    required super.projectName,
    required super.projectAddress,
    super.thumbnailUrl,
    required super.categories,
    required super.recentDocuments,
  });

  factory DocumentProjectModel.fromJson(Map<String, dynamic> json) {
    final categoryRows = json["categories"] ?? json["types"] ?? json["documentTypes"];
    final recentRows = json["recentDocuments"] ?? json["latestDocuments"] ?? json["documents"];

    final categories = categoryRows is List
        ? categoryRows.whereType<Map<String, dynamic>>().map(DocumentCategoryModel.fromJson).toList()
        : <DocumentCategoryModel>[];
    final recents = recentRows is List
        ? recentRows.whereType<Map<String, dynamic>>().map(RecentDocumentModel.fromJson).toList()
        : <RecentDocumentModel>[];

    return DocumentProjectModel(
      projectName: _readString(json, ["projectName", "name", "title"], fallback: "Untitled Project"),
      projectAddress: _readString(json, ["projectAddress", "address", "location"], fallback: "N/A"),
      thumbnailUrl: _readString(json, ["thumbnailUrl", "thumbnail", "imageUrl"]).isEmpty
          ? null
          : _readString(json, ["thumbnailUrl", "thumbnail", "imageUrl"]),
      categories: categories,
      recentDocuments: recents,
    );
  }

  static const List<DocumentProjectModel> dummyData = [
    DocumentProjectModel(
      projectName: "Riverside Apartment Renovation",
      projectAddress: "42 Harbor View Drive, Apt 12B",
      thumbnailUrl: "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=400&auto=format&fit=crop",
      categories: [
        DocumentCategoryModel(title: "Drawings", fileCount: 3, type: "drawings"),
        DocumentCategoryModel(title: "Invoices", fileCount: 2, type: "invoices"),
        DocumentCategoryModel(title: "Reports", fileCount: 1, type: "reports"),
        DocumentCategoryModel(title: "Contracts", fileCount: 2, type: "contracts"),
      ],
      recentDocuments: [
        RecentDocumentModel(
          title: "Floor Plan - Final Rev 3",
          category: "Drawings",
          dateLabel: "Jan 15",
        ),
        RecentDocumentModel(
          title: "Floor Plan - Final Rev 3",
          category: "Drawings",
          dateLabel: "Jan 15",
        ),
        RecentDocumentModel(
          title: "Floor Plan - Final Rev 3",
          category: "Drawings",
          dateLabel: "Jan 15",
        ),
        RecentDocumentModel(
          title: "Invoice# INV - 2024-001",
          category: "Invoice",
          dateLabel: "Dec 1",
        ),
      ],
    ),
    DocumentProjectModel(
      projectName: "Cityline Duplex Build",
      projectAddress: "15 Lakefront Ave, Unit 12",
      thumbnailUrl: "https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?w=400&auto=format&fit=crop",
      categories: [
        DocumentCategoryModel(title: "Drawings", fileCount: 5, type: "drawings"),
        DocumentCategoryModel(title: "Invoices", fileCount: 1, type: "invoices"),
        DocumentCategoryModel(title: "Reports", fileCount: 2, type: "reports"),
        DocumentCategoryModel(title: "Contracts", fileCount: 1, type: "contracts"),
      ],
      recentDocuments: [
        RecentDocumentModel(
          title: "Electrical Layout - Revision B",
          category: "Drawings",
          dateLabel: "Feb 2",
        ),
        RecentDocumentModel(
          title: "Invoice# INV - 2024-117",
          category: "Invoice",
          dateLabel: "Jan 20",
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

int _readInt(
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
