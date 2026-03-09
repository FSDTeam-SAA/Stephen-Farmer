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

  @override
  Future<void> forgotPassword({required String email}) async {
    await apiClient.post(
      AuthEndpoints.forgotPassword,
      data: {
        "email": email.trim(),
      },
    );
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    await apiClient.post(
      AuthEndpoints.verifyOtp,
      data: {
        "email": email.trim(),
        "otp": otp.trim(),
      },
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await apiClient.post(
      AuthEndpoints.resetPassword,
      data: {
        "email": email.trim(),
        "otp": otp.trim(),
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      },
    );
  }
}
