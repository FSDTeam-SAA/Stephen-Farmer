import 'dart:async';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../../core/network/api_service/api_endpoints.dart';
import '../../../../core/network/api_service/token_meneger.dart';
import '../model/app_notification_model.dart';

class NotificationSocketService {
  NotificationSocketService();

  io.Socket? _socket;
  final _notificationController =
      StreamController<AppNotificationModel>.broadcast();

  Stream<AppNotificationModel> get notifications =>
      _notificationController.stream;

  Future<void> connect() async {
    if (_socket?.connected == true) return;

    final token = await TokenManager.getToken();
    final userId = _extractUserIdFromJwt(token);

    _socket = io.io(baseUrl.replaceFirst('/api/v1', ''), <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': <String, dynamic>{
        if (token != null && token.isNotEmpty) 'token': 'Bearer $token',
      },
    });

    _socket?.onConnect((_) {
      if (userId.isNotEmpty) {
        _socket?.emit('joinUserRoom', userId);
      }
    });

    _socket?.on('notification:new', (payload) {
      if (payload is Map<String, dynamic>) {
        _notificationController.add(AppNotificationModel.fromJson(payload));
      }
    });

    _socket?.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  Future<void> dispose() async {
    disconnect();
    await _notificationController.close();
  }

  String _extractUserIdFromJwt(String? token) {
    if (token == null || token.trim().isEmpty) return '';
    final parts = token.split('.');
    if (parts.length < 2) return '';

    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final data = jsonDecode(payload);
      if (data is Map<String, dynamic>) {
        final id = data['_id'] ?? data['id'] ?? data['userId'];
        if (id != null && id.toString().trim().isNotEmpty) {
          return id.toString().trim();
        }
      }
    } catch (_) {}
    return '';
  }
}
