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

  SignupRequested(this.username, this.email, this.password);
}

class LogoutRequested extends AuthEvent {}
