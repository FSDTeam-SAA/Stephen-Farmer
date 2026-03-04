import 'package:dio/dio.dart';

import '../../../../core/network/api_service/api_client.dart';
import '../../../../core/network/api_service/api_endpoints.dart';
import '../../domain/repo/auth_repo.dart';
import '../model/login_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl(this.apiClient);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final Response response = await apiClient.post(
        AuthEndpoints.login,
        data: request.toJson(),
      );

      if (response.data is Map<String, dynamic>) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout({String? refreshToken}) async {
    try {
      await apiClient.post(
        AuthEndpoints.logout,
        data: refreshToken == null || refreshToken.trim().isEmpty
            ? {}
            : {"refreshToken": refreshToken},
      );
    } catch (_) {
      // Local logout will still proceed from controller.
    }
  }
}
