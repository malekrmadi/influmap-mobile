import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Erreur spécifique pour les échecs du serveur
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

// Erreur spécifique pour les échecs liés au cache
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

// Erreur pour une mauvaise authentification
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}
