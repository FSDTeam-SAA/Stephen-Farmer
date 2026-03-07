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

  static String assignManager(String projectId) =>
      "/admin/projects/$projectId/assign-manager";

  // Financial
  static const String financialOverview = "/admin/financial-overview";
}

// ================= MANAGER =================
class ManagerEndpoints {
  static const String getProjects = "/manager/projects";

  static String getProjectDetails(String projectId) =>
      "/manager/projects/$projectId";

  static String updateProjectStatus(String projectId) =>
      "/manager/projects/$projectId/status";

  static String addExpense(String projectId) =>
      "/manager/projects/$projectId/expenses";

  static String getExpenses(String projectId) =>
      "/manager/projects/$projectId/expenses";
}

// ================= CLIENT =================
class ClientEndpoints {
  static const String getMyProjects = "/client/projects";

  static String getProjectDetails(String projectId) =>
      "/client/projects/$projectId";

  static String makePayment(String projectId) =>
      "/client/projects/$projectId/payment";

  static String getPayments(String projectId) =>
      "/client/projects/$projectId/payments";
}

// ================= PROJECT =================
class ProjectEndpoints {
  static const String getAll = "/projects";
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
  static const String create = "/updates";
  static String getByProject(String projectId) => "/updates/project/$projectId";
  static String like(String updateId) => "/updates/$updateId/like";
  static String share(String updateId) => "/updates/$updateId/share";
  static String addComment(String updateId) => "/updates/$updateId/comments";
  static String getComments(String updateId) => "/updates/$updateId/comments";
}

// ================= PROGRESS =================
class ProgressEndpoints {
  static const String getProjects = "/progress/projects";
  static String submitProgress(String projectId) =>
      "/projects/$projectId/progress";
}

// ================= TASK =================
class TaskEndpoints {
  static const String getProjects = "/tasks/projects";
}

// ================= FINANCIALS =================
class FinancialsEndpoints {
  static const String getProjects = "/projects";

  static String phasePayment(String projectId) =>
      "/projects/$projectId/phase-payment";

  static String financialSummary(String projectId) =>
      "/projects/$projectId/financial-summary";
}

// ================= DOCUMENTS =================
class DocumentEndpoints {
  static const String getProjects = "/documents/projects";
}

// ================= NOTIFICATION =================
class NotificationEndpoints {
  static const String getAll = "/notifications";
  static const String markAllAsRead = "/notifications/read-all";

  static String markAsRead(String id) => "/notifications/$id/read";
}
