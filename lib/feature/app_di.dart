import 'package:get/get.dart';

import '../core/network/api_service/api_client.dart';
import '../core/network/api_service/api_endpoints.dart';
import 'auth/data/repo/auth_repo_impl.dart';
import 'auth/domain/repo/auth_repo.dart';
import 'auth/presentation/controller/login_controller.dart';

class AppDependencies {
  static void init() {
    // ApiClient globally
    Get.put<ApiClient>(
      ApiClient(baseUrl),
      permanent: true,
    );

    // Repositories (lazy)
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<AuthRepository>()),
      fenix: true,
    );
  }
}
