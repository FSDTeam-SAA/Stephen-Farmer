import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/images.dart';
import 'login_screen_view.dart';
import '../widgets/WorkspaceCard.dart';

class RoleSelectScreenView extends StatelessWidget {
  const RoleSelectScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Welcome Text
                const Text(
                  'Welcome',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select your workspace to continue',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                ),

                const SizedBox(height: 60),

                // BUILD STUDIO Card
                WorkspaceCard(
                  image: AssetsImages.constructionIgm,
                  subtitle: 'Construction Management',
                  onTap: () {
                    Get.to(() => LoginScreenView(loginRole: "construction"));
                  },
                ),

                const SizedBox(height: 24),

                // NF Card
                WorkspaceCard(
                  image: AssetsImages.interiorImg,
                  imageHeight: 60,
                  imageWidth: 64,
                  subtitle: 'Interior Design',
                  onTap: () {
                    Get.to(() => LoginScreenView(loginRole: "interior"));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
