import 'package:stephen_farmer/core/network/api_service/api_client.dart';
import 'package:stephen_farmer/core/network/api_service/api_endpoints.dart';

import '../../domain/entities/app_notification_entity.dart';
import '../../domain/repository/notification_repository.dart';
import '../model/app_notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<AppNotificationEntity>> fetchNotifications() async {
    try {
      final response = await _apiClient.get(NotificationEndpoints.getAll);
      final rows = _extractRows(response.data);
      return rows.map(AppNotificationModel.fromJson).toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _apiClient.patch(NotificationEndpoints.markAllAsRead);
    } catch (e) {
      throw Exception('Failed to mark all notifications read: $e');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiClient.patch(NotificationEndpoints.markAsRead(notificationId));
    } catch (e) {
      throw Exception('Failed to mark notification read: $e');
    }
  }

  List<Map<String, dynamic>> _extractRows(dynamic payload) {
    dynamic source = payload;

    if (source is Map<String, dynamic>) {
      source =
          source['data'] ??
          source['notifications'] ??
          source['items'] ??
          source['results'] ??
          source;

      if (source is Map<String, dynamic>) {
        source =
            source['notifications'] ??
            source['items'] ??
            source['results'] ??
            source['data'] ??
            [];
      }
    }

    if (source is List) {
      return source.whereType<Map<String, dynamic>>().toList();
    }

    return <Map<String, dynamic>>[];
  }
}
