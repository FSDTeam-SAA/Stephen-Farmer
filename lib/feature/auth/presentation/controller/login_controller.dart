import 'package:get/get.dart';
import 'package:stephen_farmer/app_ground_view.dart';

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
  final RxString userRole = ''.obs; // role: "client" / "manager" / ...

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
        role.value = response.data!.category.toLowerCase();
        userRole.value = response.data!.role.toLowerCase();

        Get.offAll(() => const AppGroundView());
      } else {
        Get.snackbar("Login Failed", response.message);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Login function
  Future<void> login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar('Success', 'Login successful', snackPosition: SnackPosition.BOTTOM);

      // Navigate to home
      Get.offAll(() => const AppGroundView());
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
