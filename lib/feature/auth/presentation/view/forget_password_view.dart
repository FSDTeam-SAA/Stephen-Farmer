import 'package:flutter/material.dart';
import 'package:stephen_farmer/core/utils/images.dart';
import 'package:stephen_farmer/core/utils/style.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 130),
            Center(child: Image.asset(AssetsImages.constructionIgm, height: 64, width: 166)),
            SizedBox(height: 30),
            Center(
              child: Text(
                "Forgot Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
            SizedBox(height: 50),
            Text("Select which contact details should we use to reset your password", style: AppTextStyles.samiMedium()),

            SizedBox(height: 20),
            Container(
              height: 88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1.5, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
