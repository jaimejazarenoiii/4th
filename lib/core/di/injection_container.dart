import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/jwt_storage_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/inventory/data/datasources/inventory_local_data_source.dart';
import '../../features/inventory/data/repositories/inventory_repository_impl.dart';
import '../../features/inventory/domain/repositories/inventory_repository.dart';
import '../../features/inventory/domain/usecases/get_spaces.dart';
import '../../features/inventory/domain/usecases/add_space.dart';
import '../../features/inventory/domain/usecases/update_space.dart';
import '../../features/inventory/domain/usecases/delete_space.dart';
import '../../features/inventory/domain/usecases/storage_usecases.dart';
import '../../features/inventory/domain/usecases/item_usecases.dart';
import '../../features/inventory/presentation/bloc/inventory_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Auth BLoC
  sl.registerFactory(() => AuthBloc(
        checkAuthStatus: sl(),
        signIn: sl(),
        signUp: sl(),
        signOut: sl(),
      ));

  // Auth use cases
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // Auth repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  //! Features - Inventory
  // Bloc
  sl.registerFactory(
    () => InventoryBloc(
      getSpaces: sl(),
      addSpace: sl(),
      updateSpace: sl(),
      deleteSpace: sl(),
      addStorage: sl(),
      updateStorage: sl(),
      deleteStorage: sl(),
      addItem: sl(),
      updateItem: sl(),
      deleteItem: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSpaces(sl()));
  sl.registerLazySingleton(() => AddSpace(sl()));
  sl.registerLazySingleton(() => UpdateSpace(sl()));
  sl.registerLazySingleton(() => DeleteSpace(sl()));
  sl.registerLazySingleton(() => AddStorage(sl()));
  sl.registerLazySingleton(() => UpdateStorage(sl()));
  sl.registerLazySingleton(() => DeleteStorage(sl()));
  sl.registerLazySingleton(() => AddItem(sl()));
  sl.registerLazySingleton(() => UpdateItem(sl()));
  sl.registerLazySingleton(() => DeleteItem(sl()));

  // Repository
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<InventoryLocalDataSource>(
    () => InventoryLocalDataSourceImpl(
      sharedPreferences: sl(),
      uuid: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton(() => const Uuid());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => JwtStorageService(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}

