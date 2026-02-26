import '../../data/models/user_model.dart';
import '../repositories/user_repository.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<List<UserModel>> call() async {
    return await repository.getUsers();
  }
}

class GetUserById {
  final UserRepository repository;

  GetUserById(this.repository);

  Future<UserModel> call(String id) async {
    return await repository.getUserById(id);
  }
}

class CreateUser {
  final UserRepository repository;

  CreateUser(this.repository);

  Future<UserModel> call(UserModel user) async {
    return await repository.createUser(user);
  }
}

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<UserModel> call(UserModel user) async {
    return await repository.updateUser(user);
  }
}

class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteUser(id);
  }
}
