import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stephen_farmer/core/utils/images.dart';
import 'package:stephen_farmer/core/utils/style.dart';

import '../../../../core/common/role_bg_color.dart';

class ForgetPasswordView extends StatelessWidget {
  final String category;

  const ForgetPasswordView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final bool isInterior = RoleBgColor.isInterior(category);
    final Color titleColor = isInterior ? Colors.black : Colors.white;
    final Color bodyColor = isInterior ? const Color(0xFF2B2B2B) : Colors.white;
    final Color borderColor = isInterior
        ? const Color(0xFF2B2B2B)
        : Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: RoleBgColor.overlayStyle(category),
      child: Scaffold(
        backgroundColor: RoleBgColor.scaffoldColor(category),
        body: Container(
          decoration: RoleBgColor.decoration(category),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 90),
                  Center(
                    child: isInterior
                        ? Image.asset(
                            AssetsImages.interiorImg,
                            height: 141,
                            width: 150,
                          )
                        : Image.asset(
                            AssetsImages.constructionIgm,
                            height: 64,
                            width: 166,
                          ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "Select which contact details should we use to reset your password",
                    style: AppTextStyles.samiMedium(color: bodyColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1.5, color: borderColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
