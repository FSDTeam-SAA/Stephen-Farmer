import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_ground_view.dart';
import 'feature/app_di.dart';
import 'feature/auth/presentation/controller/login_controller.dart';
import 'feature/auth/presentation/view/role_screen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDependencies.init();

  final LoginController loginController = Get.find<LoginController>();
  final bool hasSession = await loginController.restoreSession();

  runApp(MyApp(hasSession: hasSession));
}

class MyApp extends StatelessWidget {
  final bool hasSession;
  const MyApp({super.key, required this.hasSession});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home: hasSession ? const AppGroundView() : const RoleSelectScreenView(),
    );
  }
}
