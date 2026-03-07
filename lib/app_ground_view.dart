import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';
import 'package:stephen_farmer/feature/financials/presentation/view/financials_screen_view.dart';

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

  bool get _isManager => _auth.normalizedRoleKey == 'manager';

  List<Widget> get _tabs => [
        UpdateScreenView(loginCategory: _auth.role.value),
        const ProgressScreenView(),
        if (!_isManager) const FinancialsScreenView(),
        const TaskScreenView(),
        const DocumentScreenView(),
      ];

  @override
  Widget build(BuildContext context) {
    final tabs = _tabs;
    final int safeIndex = _currentIndex < tabs.length ? _currentIndex : 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1218),
      body: IndexedStack(index: safeIndex, children: tabs),
      bottomNavigationBar: BottomNavBar(
        currentIndex: safeIndex,
        includeFinancials: !_isManager,
        onTap: (int index) {
          if (safeIndex == index) {
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
