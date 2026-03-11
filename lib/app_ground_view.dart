import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';
import 'package:stephen_farmer/feature/documents/presentation/controller/document_controller.dart';
import 'package:stephen_farmer/feature/financials/presentation/controller/financials_controller.dart';
import 'package:stephen_farmer/feature/financials/presentation/view/financials_screen_view.dart';
import 'package:stephen_farmer/feature/notifications/presentation/controller/notification_controller.dart';
import 'package:stephen_farmer/feature/progress/presentation/controller/progress_controller.dart';

import 'package:stephen_farmer/feature/progress/presentation/view/progress_screen_view.dart';
import 'package:stephen_farmer/feature/tasks/presentation/controller/task_controller.dart';
import 'package:stephen_farmer/feature/tasks/presentation/view/task_screen_view.dart';
import 'package:stephen_farmer/feature/update/presentation/controller/update_controller.dart';
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
  bool _didBootstrapData = false;

  bool get _isManager => _auth.normalizedRoleKey == 'manager';

  List<Widget> get _tabs => [
    UpdateScreenView(loginCategory: _auth.role.value),
    const ProgressScreenView(),
    if (!_isManager) const FinancialsScreenView(),
    const TaskScreenView(),
    const DocumentScreenView(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrapDataAfterLogin();
    });
  }

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
          setState(() {
            _currentIndex = index;
          });
          _refreshCurrentTabIfNeeded(index);
        },
      ),
    );
  }

  Future<void> _bootstrapDataAfterLogin() async {
    if (_didBootstrapData) return;
    _didBootstrapData = true;

    await _refreshAllTabsData();

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    await _retryEmptyLoads();
  }

  Future<void> _refreshAllTabsData() async {
    final updateController = _resolveUpdateController();
    final progressController = Get.find<ProgressController>();
    final taskController = Get.find<TaskController>();
    final documentController = Get.find<DocumentController>();
    final notificationController = Get.find<NotificationController>();
    final financialsController = _isManager
        ? null
        : Get.find<FinancialsController>();

    await _safeRun(updateController.refreshAll);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    await _safeRun(progressController.refreshProjects);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    await _safeRun(taskController.refreshProjects);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    if (financialsController != null) {
      await _safeRun(financialsController.refreshProjects);
      await Future<void>.delayed(const Duration(milliseconds: 80));
    }
    await _safeRun(documentController.refreshProjects);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    await _safeRun(notificationController.refreshNotifications);
  }

  Future<void> _retryEmptyLoads() async {
    final updateController = _resolveUpdateController();
    final progressController = Get.find<ProgressController>();
    final taskController = Get.find<TaskController>();
    final documentController = Get.find<DocumentController>();
    final notificationController = Get.find<NotificationController>();
    final financialsController = _isManager
        ? null
        : Get.find<FinancialsController>();

    if (!updateController.isLoading.value &&
        updateController.projects.isEmpty &&
        updateController.errorMessage.value.isNotEmpty) {
      await _safeRun(updateController.refreshAll);
    }
    if (!progressController.isLoading.value &&
        progressController.projects.isEmpty &&
        progressController.errorMessage.value.isNotEmpty) {
      await _safeRun(progressController.refreshProjects);
    }
    if (!taskController.isLoading.value &&
        taskController.projects.isEmpty &&
        taskController.errorMessage.value.isNotEmpty) {
      await _safeRun(taskController.refreshProjects);
    }
    if (financialsController != null &&
        !financialsController.isLoading.value &&
        financialsController.projects.isEmpty &&
        financialsController.errorMessage.value.isNotEmpty) {
      await _safeRun(financialsController.refreshProjects);
    }
    if (!documentController.isLoading.value &&
        documentController.projects.isEmpty &&
        documentController.errorMessage.value.isNotEmpty) {
      await _safeRun(documentController.refreshProjects);
    }
    if (!notificationController.isLoading.value &&
        notificationController.notifications.isEmpty &&
        notificationController.errorMessage.value.isNotEmpty) {
      await _safeRun(notificationController.refreshNotifications);
    }
  }

  void _refreshCurrentTabIfNeeded(int index) {
    switch (index) {
      case 0:
        final controller = _resolveUpdateController();
        if (controller.projects.isEmpty && !controller.isLoading.value) {
          _safeRun(controller.refreshAll);
        }
        break;
      case 1:
        final controller = Get.find<ProgressController>();
        if (controller.projects.isEmpty && !controller.isLoading.value) {
          _safeRun(controller.refreshProjects);
        }
        break;
      case 2:
        if (_isManager) {
          final taskController = Get.find<TaskController>();
          if (taskController.projects.isEmpty &&
              !taskController.isLoading.value) {
            _safeRun(taskController.refreshProjects);
          }
          return;
        }
        final financialsController = Get.find<FinancialsController>();
        if (financialsController.projects.isEmpty &&
            !financialsController.isLoading.value) {
          _safeRun(financialsController.refreshProjects);
        }
        break;
      case 3:
        final taskController = Get.find<TaskController>();
        if (taskController.projects.isEmpty &&
            !taskController.isLoading.value) {
          _safeRun(taskController.refreshProjects);
        }
        break;
      case 4:
        final controller = Get.find<DocumentController>();
        if (controller.projects.isEmpty && !controller.isLoading.value) {
          _safeRun(controller.refreshProjects);
        }
        break;
      default:
        break;
    }
  }

  Future<void> _safeRun(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {}
  }

  UpdateController _resolveUpdateController() {
    if (Get.isRegistered<UpdateController>()) {
      return Get.find<UpdateController>();
    }
    return Get.put(UpdateController());
  }
}
