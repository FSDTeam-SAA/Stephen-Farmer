

enum UserRole {
  constructionUser,
  constructionManager,
  interiorUser,
  interiorManager,
}

UserRole parseRole(String role) {
  switch (role) {
    case "construction_user":
      return UserRole.constructionUser;
    case "construction_manager":
      return UserRole.constructionManager;
    case "interior_user":
      return UserRole.interiorUser;
    case "interior_manager":
      return UserRole.interiorManager;
    default:
      return UserRole.constructionUser;
  }
}