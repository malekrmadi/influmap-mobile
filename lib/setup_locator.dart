import 'package:get_it/get_it.dart';
//import 'package:http/http.dart' as http;
import 'package:auth/core/network/api_client.dart';
import 'package:auth/modules/auth/data/datasources/auth_remote_data_source.dart';
import 'package:auth/modules/auth/data/repositories/auth_repository_impl.dart';
import 'package:auth/modules/auth/domain/repositories/auth_repository.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Register ApiClient
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Register AuthRemoteDataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(sl()));

  // Register AuthRepositoryImpl
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));

  // Register AuthBloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl())); // Pass sl() as the positional argument
}

