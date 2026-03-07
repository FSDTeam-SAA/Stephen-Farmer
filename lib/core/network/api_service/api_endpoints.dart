// ================= BASE =================
const String baseUrl = "http://localhost:8000/api/v1";

// ================= AUTH =================
class AuthEndpoints {
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String verifyOtp = "/auth/verify";
  static const String forgotPassword = "/auth/forget";
  static const String resetPassword = "/auth/reset-password";
  static const String changePassword = "/auth/change-password";
  static const String refreshToken = "/auth/refresh-token";
  static const String logout = "/auth/logout";
}

// ================= USER PROFILE =================
class UserProfileEndpoints {
  static const String getProfile = "/user/profile";
  static const String updateProfile = "/user/profile";
  static const String changePassword = "/user/password";
}

// ================= ADMIN =================
class AdminEndpoints {
  // Managers
  static const String createManager = "/admin/managers";
  static const String getManagers = "/admin/managers";

  // Projects
  static const String createProject = "/admin/projects";
  static const String getProjects = "/admin/projects";

  static String assignManager(String projectId) => "/admin/projects/$projectId/assign-manager";

  // Financial
  static const String financialOverview = "/admin/financial-overview";
}

// ================= MANAGER =================
class ManagerEndpoints {
  static const String getProjects = "/manager/projects";

  static String getProjectDetails(String projectId) => "/manager/projects/$projectId";

  static String updateProjectStatus(String projectId) => "/manager/projects/$projectId/status";

  static String addExpense(String projectId) => "/manager/projects/$projectId/expenses";

  static String getExpenses(String projectId) => "/manager/projects/$projectId/expenses";
}

// ================= CLIENT =================
class ClientEndpoints {
  static const String getMyProjects = "/client/projects";

  static String getProjectDetails(String projectId) => "/client/projects/$projectId";

  static String makePayment(String projectId) => "/client/projects/$projectId/payment";

  static String getPayments(String projectId) => "/client/projects/$projectId/payments";
}

// ================= PROJECT =================
class ProjectEndpoints {
  static String getById(String id) => "/projects/$id";
  static String update(String id) => "/projects/$id";
  static String delete(String id) => "/projects/$id";
}

// ================= PAYMENT =================
class PaymentEndpoints {
  static const String create = "/payments";

  static String byId(String id) => "/payments/$id";

  static const String history = "/payments/history";
}

// ================= DASHBOARD =================
class DashboardEndpoints {
  static const String roleDashboard = "/dashboard";
}

// ================= UPDATE =================
class UpdateEndpoints {
  static const String getUpdates = "/updates";
}

// ================= PROGRESS =================
class ProgressEndpoints {
  static const String getProjects = "/progress/projects";
  static const String submitProgress = "/progress";
}

// ================= TASK =================
class TaskEndpoints {
  static const String getProjects = "/tasks/projects";
}

// ================= FINANCIALS =================
class FinancialsEndpoints {
  static const String getProjects = "/tasks/financial-projects";
}

// ================= DOCUMENTS =================
class DocumentEndpoints {
  static const String getProjects = "/documents/projects";
}

// ================= NOTIFICATION =================
class NotificationEndpoints {
  static const String getAll = "/notifications";

  static String markAsRead(String id) => "/notifications/$id/read";
}
