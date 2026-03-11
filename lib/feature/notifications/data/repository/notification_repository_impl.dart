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
      final response = await _getWithFallback(
        primary: NotificationEndpoints.getAll,
        alternatives: const <String>[
          '/notification',
          '/notification/',
          '/notifications/',
        ],
      );
      final rows = _extractRows(response.data);
      return rows.map(AppNotificationModel.fromJson).toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _patchWithFallback(
        primary: NotificationEndpoints.markAllAsRead,
        alternatives: const <String>[
          '/notification/read-all',
          '/notification/read-all/',
          '/notifications/read-all/',
        ],
      );
    } catch (e) {
      throw Exception('Failed to mark all notifications read: $e');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await _patchWithFallback(
        primary: NotificationEndpoints.markAsRead(notificationId),
        alternatives: <String>[
          '/notification/$notificationId/read',
          '/notification/$notificationId/read/',
          '/notifications/$notificationId/read/',
        ],
      );
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
          source['notification'] ??
          source['docs'] ??
          source['rows'] ??
          source['items'] ??
          source['results'] ??
          source;

      if (source is Map<String, dynamic>) {
        source =
            source['notifications'] ??
            source['notification'] ??
            source['docs'] ??
            source['rows'] ??
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

  Future<dynamic> _getWithFallback({
    required String primary,
    required List<String> alternatives,
  }) async {
    try {
      return await _apiClient.get(primary);
    } catch (_) {
      for (final path in alternatives) {
        try {
          return await _apiClient.get(path);
        } catch (_) {}
      }
      rethrow;
    }
  }

  Future<dynamic> _patchWithFallback({
    required String primary,
    required List<String> alternatives,
  }) async {
    try {
      return await _apiClient.patch(primary);
    } catch (_) {
      for (final path in alternatives) {
        try {
          return await _apiClient.patch(path);
        } catch (_) {}
      }
      rethrow;
    }
  }
}
