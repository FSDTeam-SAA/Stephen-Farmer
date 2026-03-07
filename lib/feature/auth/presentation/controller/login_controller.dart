import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:stephen_farmer/app_ground_view.dart';
import 'package:stephen_farmer/feature/auth/presentation/view/role_screen_view.dart';

import '../../../../core/network/api_service/token_meneger.dart';
import '../../data/model/login_model.dart';
import '../../domain/repo/auth_repo.dart';

class LoginController extends GetxController {
  final AuthRepository repository;

  LoginController(this.repository);

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool rememberMe = false.obs;
  final RxString role = ''.obs; // category: "interior" / "construction"
  final RxString userRole = ''.obs; // role: "client" / "manager"

  // Text controllers
  final RxString email = ''.obs;
  final RxString password = ''.obs;

  void setRoleFromApi(String apiRole) {
    role.value = apiRole;
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Toggle remember me
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  // Update email
  void updateEmail(String value) {
    email.value = value;
  }

  // Update password
  void updatePassword(String value) {
    password.value = value;
  }

  String get categoryKey => role.value.trim().toLowerCase();
  String get roleKey => userRole.value.trim().toLowerCase();
  String get normalizedRoleKey => _normalizeRole(roleKey);
  String get scopeKey => '${categoryKey}_$normalizedRoleKey';

  bool get isInterior => categoryKey == 'interior';
  bool get isConstruction => categoryKey == 'construction';
  bool get isClient => roleKey == 'client' || roleKey == 'user';
  bool get isManager => roleKey == 'manager';
  bool get isInteriorUser => scopeKey == 'interior_user';
  bool get isInteriorManager => scopeKey == 'interior_manager';
  bool get isConstructionUser => scopeKey == 'construction_user';
  bool get isConstructionManager => scopeKey == 'construction_manager';

  bool hasScope(String scope) => scopeKey == scope.trim().toLowerCase();

  bool hasAnyScope(List<String> scopes) {
    return scopes.map((e) => e.trim().toLowerCase()).contains(scopeKey);
  }

  bool hasAccess({String? category, String? userRole}) {
    final categoryMatch = category == null
        ? true
        : categoryKey == category.trim().toLowerCase();
    final roleMatch = userRole == null
        ? true
        : normalizedRoleKey == _normalizeRole(userRole);
    return categoryMatch && roleMatch;
  }

  bool hasAnyAccess({List<String>? categories, List<String>? userRoles}) {
    final categoryMatch = categories == null || categories.isEmpty
        ? true
        : categories.map((e) => e.trim().toLowerCase()).contains(categoryKey);
    final roleMatch = userRoles == null || userRoles.isEmpty
        ? true
        : userRoles.map(_normalizeRole).contains(normalizedRoleKey);
    return categoryMatch && roleMatch;
  }

  String _normalizeRole(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'client') return 'user';
    return normalized;
  }

  Future<bool> restoreSession() async {
    final loggedIn = await TokenManager.isLoggedIn();
    if (!loggedIn) return false;

    final savedCategory =
        (await TokenManager.getCategory())?.trim().toLowerCase() ?? '';
    final savedUserRole =
        (await TokenManager.getRole())?.trim().toLowerCase() ?? '';

    if (savedCategory.isEmpty || savedUserRole.isEmpty) {
      return false;
    }

    role.value = savedCategory;
    userRole.value = savedUserRole;
    return true;
  }

  Future<void> loginUser({
    required String email,
    required String password,
    required String category, // "interior" / "construction"
  }) async {
    if (email.trim().isEmpty || password.isEmpty || category.trim().isEmpty) {
      Get.snackbar("Error", "Email, password and category are required");
      return;
    }

    try {
      isLoading.value = true;
      final normalizedCategory = category.trim().toLowerCase();
      role.value = normalizedCategory;

      final request = LoginRequest(
        email: email,
        password: password,
        category: normalizedCategory,
      );

      final response = await repository.login(request);

      if (response.success && response.data != null) {
        await TokenManager.accessToken(response.data!.accessToken);
        await TokenManager.refreshToken(response.data!.refreshToken);
        role.value = response.data!.category.trim().toLowerCase();
        userRole.value = response.data!.role.trim().toLowerCase();
        await TokenManager.saveCategory(role.value);
        await TokenManager.saveRole(userRole.value);

        Get.offAll(() => const AppGroundView());
      } else {
        Get.snackbar("Login Failed", response.message);
      }
    } catch (e) {
      Get.snackbar("Error", _friendlyLoginError(e));
    } finally {
      isLoading.value = false;
    }
  }

  String _friendlyLoginError(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final apiMessage = _extractApiMessage(error.response?.data);

      if (statusCode == 400 || statusCode == 401) {
        return apiMessage ?? "Invalid email or password.";
      }
      if (statusCode == 404) {
        return "Login service is unavailable right now. Please try again.";
      }
      if (statusCode != null && statusCode >= 500) {
        return "Server error. Please try again shortly.";
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return "Request timed out. Please check your connection and try again.";
        case DioExceptionType.connectionError:
          return "No internet connection. Please check your network.";
        case DioExceptionType.cancel:
          return "Request was cancelled.";
        default:
          return apiMessage ?? "Unable to sign in. Please try again.";
      }
    }

    return "Unable to sign in. Please try again.";
  }

  String? _extractApiMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data["message"] ?? data["error"];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
    }
    return null;
  }

  Future<void> logoutUser() async {
    try {
      final String? refreshToken = await TokenManager.getRefreshToken();
      await repository.logout(refreshToken: refreshToken);
    } finally {
      await TokenManager.clearToken();
      role.value = '';
      userRole.value = '';
      email.value = '';
      password.value = '';
      rememberMe.value = false;

      Get.offAll(() => const RoleSelectScreenView());
    }
  }

  // Login function
  Future<void> login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter email and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Login successful',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to home
      Get.offAll(() => const AppGroundView());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
