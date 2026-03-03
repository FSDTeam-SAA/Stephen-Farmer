import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';

import 'package:stephen_farmer/feature/progress/presentation/view/progress_screen_view.dart';
import 'package:stephen_farmer/feature/tasks/presentation/view/task_screen_view.dart';
import 'package:stephen_farmer/feature/update/presentation/view/update_screen_view.dart';

import 'core/common/widgets/bottomNavBar.dart';
import 'feature/documents/presentation/view/document_screen_view.dart';

class AppGroundView extends StatefulWidget {
  const AppGroundView({super.key});

  @override
  State<AppGroundView> createState() => _AppGroundViewState();
}

class _AppGroundViewState extends State<AppGroundView> {
  final LoginController _auth = Get.find<LoginController>();
  int _currentIndex = 0;

  List<Widget> get _tabs => [
    UpdateScreenView(
      loginCategory: _auth.role.value,
      userRole: _auth.userRole.value,
    ),
    const ProgressScreenView(),
    const TaskScreenView(),
    const DocumentScreenView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1218),
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _tabs),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          if (_currentIndex == index) {
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
