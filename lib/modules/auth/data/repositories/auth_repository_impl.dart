import 'package:auth/core/errors/failure.dart';
import 'package:auth/modules/auth/data/datasources/auth_remote_data_source.dart';
import 'package:auth/modules/auth/domain/entities/user.dart';
import 'package:auth/modules/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    print("Début de login() avec email: $email, password: $password");
    try {
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure("Erreur lors de la connexion : ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, User>> signup(String username, String email, String password) async {
    try {
      final user = await remoteDataSource.signup(username, email, password);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure("Erreur lors de l'inscription : ${e.toString()}"));
    }
  }
 @override
  Future<Either<Failure, void>> logout() async {
    print("Déconnexion réussie");
    return Right(null);
  
  }

}
