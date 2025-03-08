import 'package:auth/modules/auth/domain/repositories/auth_repository.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_event.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    print("LoginRequested event received: ${event.email}, ${event.password}");
    emit(AuthLoading());
    final result = await repository.login(event.email, event.password);
    result.fold(
     (failure) {
      print("Login failed: $failure");
      emit(AuthFailure("Login Failed"));
    },
    (user) {
      print("Login successful: ${user.email}");
      emit(AuthSuccess(user));
    },
    );
  }

  Future<void> _onSignupRequested(SignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await repository.signup(event.username, event.email, event.password);
    result.fold(
      (failure) => emit(AuthFailure("Signup Failed")),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await repository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

}
