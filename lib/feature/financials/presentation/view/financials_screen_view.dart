import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';

import '../controller/financials_controller.dart';
import '../widgets/financials_budget_metric_card.dart';
import '../widgets/financials_project_dropdown_card.dart';
import '../widgets/financials_payment_schedule_item_card.dart';
import '../widgets/financials_remaining_balance_card.dart';

class FinancialsScreenView extends GetView<FinancialsController> {
  const FinancialsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final project = controller.selectedProject;
      final role = Get.find<LoginController>().role.value;

      return Scaffold(
        backgroundColor: RoleBgColor.scaffoldColor(role),
        body: SafeArea(
          child: Container(
            decoration: RoleBgColor.decoration(role),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Financials',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (controller.isLoading.value && project == null)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (project == null)
                    Expanded(
                      child: Center(
                        child: Text(
                          controller.errorMessage.value.isEmpty
                              ? 'No financial data available'
                              : controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    FinancialsProjectDropdownCard(
                      projects: controller.projects,
                      selectedProjectIndex:
                          controller.selectedProjectIndex.value,
                      isMenuOpen: controller.isProjectMenuOpen.value,
                      onToggle: controller.toggleProjectMenu,
                      onSelect: controller.selectProject,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        FinancialsBudgetMetricCard(
                          title: 'Total Budget',
                          amountText: _formatAed(project.totalBudget),
                          subtitle: 'incl. AED 1,130 Variations',
                        ),
                        const SizedBox(width: 15),
                        FinancialsBudgetMetricCard(
                          title: 'Paid to Date',
                          amountText: _formatAed(project.paidToDate),
                          subtitle: '${project.paidPercent}% of total',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FinancialsRemainingBalanceCard(
                      amountText: _formatAed(project.remainingBalance),
                      paidPercent: project.paidPercent,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Payment Schedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: controller.refreshProjects,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: [
                            for (final section in project.scheduleSections) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  section.title,
                                  style: const TextStyle(
                                    color: Color(0xFFD5D5D5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              ...section.items.map(
                                (item) => FinancialsPaymentScheduleItemCard(
                                  item: item,
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                            if (controller.errorMessage.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 10,
                                ),
                                child: Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(
                                    color: Color(0xFFFF7A7A),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

String _formatAed(int amount) {
  final formatted = amount.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
  return 'AED $formatted';
}
