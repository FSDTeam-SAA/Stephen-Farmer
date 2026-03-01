import 'package:get/get.dart';

class LoginController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool rememberMe = false.obs;

  // Text controllers
  final RxString email = ''.obs;
  final RxString password = ''.obs;


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
      // Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
