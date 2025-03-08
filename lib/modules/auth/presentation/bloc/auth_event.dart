abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class SignupRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String avatar;
  final String bio;
  final int level;
  final List<String> badges;

  SignupRequested(this.username, this.email, this.password, this.avatar ,this.bio ,this.level ,this.badges);
}

class LogoutRequested extends AuthEvent {}
