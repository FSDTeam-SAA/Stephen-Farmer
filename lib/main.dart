import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stephen_farmer/app_ground_view.dart';

import 'feature/app_di.dart';
import 'feature/auth/presentation/view/role_screen_view.dart';

void main() {
  AppDependencies.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),

      //home: AppGroundView(),
      home: const RoleSelectScreenView(),
    );
  }
}
