import '../../data/model/login_model.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout({String? refreshToken});
}
