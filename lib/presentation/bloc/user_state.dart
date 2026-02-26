import '../../data/models/user_model.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;

  const UserLoaded(this.users);
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);
}
