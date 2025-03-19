import 'package:get_it/get_it.dart';
//import 'package:http/http.dart' as http;
import 'package:auth/core/network/api_client.dart';
import 'package:auth/modules/auth/data/datasources/auth_remote_data_source.dart';
import 'package:auth/modules/auth/data/repositories/auth_repository_impl.dart';
import 'package:auth/modules/auth/domain/repositories/auth_repository.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth/modules/auth/domain/repositories/place_repository.dart';
import 'package:auth/modules/auth/domain/repositories/user_repository.dart';
import 'package:auth/modules/auth/data/repositories/place_repository_impl.dart';
import 'package:auth/modules/auth/data/repositories/user_repository_impl.dart';
import 'package:auth/modules/auth/data/datasources/place_remote_data_source.dart';
import 'package:auth/modules/auth/data/datasources/user_remote_data_source.dart';
import 'package:auth/modules/auth/data/datasources/post_remote_data_source.dart';
import 'package:auth/modules/auth/data/repositories/post_repository_impl.dart';
import 'package:auth/modules/auth/domain/repositories/post_repository.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Register ApiClient
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Register DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<PlaceRemoteDataSource>(
    () => PlaceRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSource(sl()),
  );

  // Register Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PlaceRepository>(
    () => PlaceRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );

  // Register Blocs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(sl()),
  );
}

