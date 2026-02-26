import '../datasources/user_datasource.dart';
import '../models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<List<UserModel>> getUsers() async {
    return await dataSource.getUsers();
  }

  @override
  Future<UserModel> getUserById(String id) async {
    return await dataSource.getUserById(id);
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    return await dataSource.createUser(user);
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    return await dataSource.updateUser(user);
  }

  @override
  Future<void> deleteUser(String id) async {
    await dataSource.deleteUser(id);
  }
}
