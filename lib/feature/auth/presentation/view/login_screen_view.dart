import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/core/common/widgets/custom_text_field.dart';
import 'package:stephen_farmer/core/utils/images.dart';
import 'package:stephen_farmer/core/utils/style.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';

import 'forget_password_view.dart';

class LoginScreenView extends GetView<LoginController> {
  final String category;

  const LoginScreenView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final bool isInterior = RoleBgColor.isInterior(category);

    return Scaffold(
      backgroundColor: RoleBgColor.scaffoldColor(category),
      body: Container(
        decoration: RoleBgColor.decoration(category),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        tooltip: "Back",
                        icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: isInterior ? Colors.black : Colors.white),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Center(
                      child: isInterior
                          ? Image.asset(AssetsImages.interiorImg, height: 141, width: 150)
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: Image.asset(AssetsImages.constructionIgm, height: 64, width: 166),
                            ),
                    ),

                    // const SizedBox(height: 60),
                    Center(
                      child: Text('Welcome back', style: AppTextStyles.textMedium(color: isInterior ? Colors.black : Colors.white)),
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: Text(
                        'Please Login to your Account',
                        style: AppTextStyles.samiMedium(color: isInterior ? Colors.black : Colors.white),
                      ),
                    ),

                    const SizedBox(height: 48),

                    Text("Email Address", style: AppTextStyles.samiMedium(color: isInterior ? Colors.black : Colors.white)),

                    const SizedBox(height: 10),

                    CustomTextField(controller: emailController, hintText: "Email Address", isOnDarkBg: !isInterior),

                    const SizedBox(height: 15),

                    Text("Password", style: AppTextStyles.samiMedium(color: isInterior ? Colors.black : Colors.white)),

                    const SizedBox(height: 10),

                    CustomTextField(controller: passwordController, hintText: "Password", isPassword: true, isOnDarkBg: !isInterior),

                    const SizedBox(height: 20),

                    Obx(
                      () => Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 4,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: Checkbox(
                                  value: controller.rememberMe.value,
                                  onChanged: (value) {
                                    controller.rememberMe.value = value ?? false;
                                  },
                                  side: BorderSide(color: Colors.grey.shade600),
                                  checkColor: Colors.black,
                                  activeColor: Colors.white,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('Remember me', style: TextStyle(color: isInterior ? Colors.black : Colors.grey.shade300, fontSize: 14)),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(() => ForgetPasswordView());
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot your password?',
                              style: TextStyle(color: isInterior ? Colors.black54 : Colors.grey.shade400, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.loginUser(
                              email: emailController.text,
                              password: passwordController.text,
                              category: category, // "interior" / "construction"
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isInterior ? Colors.black : Colors.white.withValues(alpha: 0.9),
                            foregroundColor: isInterior ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login_outlined, size: 20),
                                    SizedBox(width: 12),
                                    Text('Sign in', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
