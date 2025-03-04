import 'package:auth/core/errors/failure.dart';
import 'package:auth/modules/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> signup(String username, String email, String password);
}
