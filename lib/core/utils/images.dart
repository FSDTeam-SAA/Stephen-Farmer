class AssetsImages {
  AssetsImages._(); // private constructor (object create prevent করবে)

  // ================== Base Path ==================
  static const String _basePath = "assets/images";
  static const String _logoPath = "assets/logo";

  // ================== App Logo ==================
  static const String appLogo = "$_basePath/app_logo.png";
  static const String splashLogo = "$_basePath/splash_logo.png";
  static const String logout = "$_basePath/logout.png";

  // ================== Icons ==================
  static const String constructionIgm = "$_basePath/constru.png";
  static const String interiorImg = "$_basePath/nidor.png";
  static const String navHome = "$_logoPath/home.png";
  static const String navFinancials = "$_logoPath/financials.png";
  static const String navProgress = "$_logoPath/progress.png";
  static const String navTask = "$_logoPath/task.png";
  static const String navDocument = "$_logoPath/doc.png";

  // ================== Onboarding ==================
  static const String onboarding1 = "$_basePath/onboarding_1.png";
  static const String onboarding2 = "$_basePath/onboarding_2.png";
  static const String onboarding3 = "$_basePath/onboarding_3.png";
}
