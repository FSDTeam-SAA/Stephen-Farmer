abstract class UserEvent {
  const UserEvent();
}

class LoadUsers extends UserEvent {}

class RefreshUsers extends UserEvent {}
