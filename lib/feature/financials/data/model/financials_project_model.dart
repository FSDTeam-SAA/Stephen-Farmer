import '../../domain/entities/financials_project_entity.dart';

class PaymentScheduleItemModel extends PaymentScheduleItemEntity {
  const PaymentScheduleItemModel({
    required super.title,
    required super.dateLabel,
    required super.amount,
    required super.isPaid,
  });

  factory PaymentScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentScheduleItemModel(
      title: _readString(json, ["title", "name"], fallback: "Payment"),
      dateLabel: _readString(json, ["dateLabel", "date"], fallback: ""),
      amount: _readInt(json, ["amount", "value"], fallback: 0),
      isPaid: _readBool(json, ["isPaid", "paid"], fallback: false),
    );
  }
}

class PaymentScheduleSectionModel extends PaymentScheduleSectionEntity {
  const PaymentScheduleSectionModel({
    required super.title,
    required super.items,
  });

  factory PaymentScheduleSectionModel.fromJson(Map<String, dynamic> json) {
    final rows = json["items"];
    final items = rows is List
        ? rows.whereType<Map<String, dynamic>>().map(PaymentScheduleItemModel.fromJson).toList()
        : <PaymentScheduleItemModel>[];

    return PaymentScheduleSectionModel(
      title: _readString(json, ["title", "name"], fallback: "Payment Section"),
      items: items,
    );
  }
}

class FinancialsProjectModel extends FinancialsProjectEntity {
  const FinancialsProjectModel({
    required super.projectName,
    required super.projectAddress,
    super.thumbnailUrl,
    required super.totalBudget,
    required super.paidToDate,
    required super.remainingBalance,
    required super.paidPercent,
    required super.scheduleSections,
  });

  factory FinancialsProjectModel.fromJson(Map<String, dynamic> json) {
    final sectionRows = json["scheduleSections"] ?? json["schedules"] ?? json["schedule"];
    final sections = sectionRows is List
        ? sectionRows.whereType<Map<String, dynamic>>().map(PaymentScheduleSectionModel.fromJson).toList()
        : <PaymentScheduleSectionModel>[];

    return FinancialsProjectModel(
      projectName: _readString(json, ["projectName", "name", "title"], fallback: "Untitled Project"),
      projectAddress: _readString(json, ["projectAddress", "address", "location"], fallback: "N/A"),
      thumbnailUrl: _readString(json, ["thumbnailUrl", "thumbnail", "imageUrl"]).isEmpty
          ? null
          : _readString(json, ["thumbnailUrl", "thumbnail", "imageUrl"]),
      totalBudget: _readInt(json, ["totalBudget", "budget"], fallback: 0),
      paidToDate: _readInt(json, ["paidToDate", "paidAmount"], fallback: 0),
      remainingBalance: _readInt(json, ["remainingBalance", "remainingAmount"], fallback: 0),
      paidPercent: _readInt(json, ["paidPercent", "progressPercent"], fallback: 0),
      scheduleSections: sections,
    );
  }

  static const List<FinancialsProjectModel> dummyData = [
    FinancialsProjectModel(
      projectName: "Riverside Apartment Renovation",
      projectAddress: "42 Harbor View Drive, Apt 8",
      thumbnailUrl: "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=400&auto=format&fit=crop",
      totalBudget: 166130,
      paidToDate: 92500,
      remainingBalance: 93630,
      paidPercent: 50,
      scheduleSections: [
        PaymentScheduleSectionModel(
          title: "Paid Amount",
          items: [
            PaymentScheduleItemModel(
              title: "Deposit",
              dateLabel: "Dec 1, 2024",
              amount: 37000,
              isPaid: true,
            ),
            PaymentScheduleItemModel(
              title: "Structural Completion",
              dateLabel: "Jan 15, 2025",
              amount: 37000,
              isPaid: true,
            ),
            PaymentScheduleItemModel(
              title: "Rough-in Completion",
              dateLabel: "Feb 1, 2025",
              amount: 37000,
              isPaid: true,
            ),
          ],
        ),
        PaymentScheduleSectionModel(
          title: "Due Amount",
          items: [
            PaymentScheduleItemModel(
              title: "Cabinetry Installation",
              dateLabel: "Feb 15, 2025",
              amount: 37000,
              isPaid: false,
            ),
            PaymentScheduleItemModel(
              title: "Cabinetry Installation",
              dateLabel: "Feb 15, 2025",
              amount: 37000,
              isPaid: false,
            ),
            PaymentScheduleItemModel(
              title: "Cabinetry Installation",
              dateLabel: "Feb 15, 2025",
              amount: 37000,
              isPaid: false,
            ),
          ],
        ),
      ],
    ),
    FinancialsProjectModel(
      projectName: "Cityline Duplex Build",
      projectAddress: "15 Lakefront Ave, Unit 12",
      thumbnailUrl: "https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?w=400&auto=format&fit=crop",
      totalBudget: 220000,
      paidToDate: 120000,
      remainingBalance: 100000,
      paidPercent: 55,
      scheduleSections: [
        PaymentScheduleSectionModel(
          title: "Paid Amount",
          items: [
            PaymentScheduleItemModel(
              title: "Initial Advance",
              dateLabel: "Nov 25, 2024",
              amount: 60000,
              isPaid: true,
            ),
            PaymentScheduleItemModel(
              title: "Framing Completion",
              dateLabel: "Jan 10, 2025",
              amount: 60000,
              isPaid: true,
            ),
          ],
        ),
        PaymentScheduleSectionModel(
          title: "Due Amount",
          items: [
            PaymentScheduleItemModel(
              title: "Interior Finishing",
              dateLabel: "Mar 2, 2025",
              amount: 50000,
              isPaid: false,
            ),
            PaymentScheduleItemModel(
              title: "Final Handover",
              dateLabel: "Apr 5, 2025",
              amount: 50000,
              isPaid: false,
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

bool _readBool(
  Map<String, dynamic> json,
  List<String> keys, {
  bool fallback = false,
}) {
  for (final key in keys) {
    final value = json[key];
    if (value is bool) return value;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == "true") return true;
      if (normalized == "false") return false;
    }
    if (value is int) {
      if (value == 1) return true;
      if (value == 0) return false;
    }
  }
  return fallback;
}
