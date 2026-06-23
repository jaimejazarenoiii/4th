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
import '../../features/inventory/data/datasources/inventory_remote_data_source.dart';
import '../../features/inventory/data/repositories/inventory_repository_impl.dart';
import '../../features/inventory/domain/repositories/inventory_repository.dart';
import '../../features/inventory/domain/usecases/get_spaces.dart';
import '../../features/inventory/domain/usecases/add_space.dart';
import '../../features/inventory/domain/usecases/update_space.dart';
import '../../features/inventory/domain/usecases/delete_space.dart';
import '../../features/inventory/domain/usecases/storage_usecases.dart';
import '../../features/inventory/domain/usecases/item_usecases.dart';
import '../../features/inventory/domain/usecases/category_usecases.dart';
import '../../features/inventory/presentation/bloc/inventory_bloc.dart';
import '../../features/inventory/presentation/bloc/create_space_bloc.dart';
import '../../features/inventory/presentation/bloc/create_storage_bloc.dart';
import '../../features/inventory/presentation/bloc/create_item_bloc.dart';
import '../../features/inventory/presentation/bloc/location_selection_bloc.dart';
import '../../features/inventory/presentation/bloc/storage_details_bloc.dart';
import '../../features/inventory/presentation/bloc/item_details_bloc.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_data.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Auth BLoC
  sl.registerFactory(
    () => AuthBloc(
      checkAuthStatus: sl(),
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
    ),
  );

  // Auth use cases
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // Auth repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl<DioClient>()),
  );

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

  // Create Space Bloc
  sl.registerFactory(() => CreateSpaceBloc(addSpace: sl()));

  // Create Storage Bloc
  sl.registerFactory(() => CreateStorageBloc(addStorage: sl()));

  // Create Item Bloc
  sl.registerFactory(
    () => CreateItemBloc(
      addItem: sl(),
      updateItem: sl(),
      getCategories: sl(),
      createCategory: sl(),
    ),
  );

  // Location Selection Bloc
  sl.registerFactory(() => LocationSelectionBloc(repository: sl()));

  // Storage Details Bloc
  sl.registerFactory(() => StorageDetailsBloc(repository: sl()));

  // Item Details Bloc
  sl.registerFactory(() => ItemDetailsBloc(repository: sl()));

  //! Features - Dashboard
  // Bloc
  sl.registerFactory(() => DashboardBloc(getDashboardData: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetDashboardData(sl()));

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(dioClient: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSpaces(sl()));
  sl.registerLazySingleton(() => AddSpace(sl()));
  sl.registerLazySingleton(() => AddStorage(sl()));
  sl.registerLazySingleton(() => UpdateSpace(sl()));
  sl.registerLazySingleton(() => DeleteSpace(sl()));
  sl.registerLazySingleton(() => UpdateStorage(sl()));
  sl.registerLazySingleton(() => DeleteStorage(sl()));
  sl.registerLazySingleton(() => AddItem(sl()));
  sl.registerLazySingleton(() => UpdateItem(sl()));
  sl.registerLazySingleton(() => DeleteItem(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => CreateCategory(sl()));

  // Repository
  sl.registerLazySingleton<InventoryRepository>(
    () =>
        InventoryRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<InventoryLocalDataSource>(
    () => InventoryLocalDataSourceImpl(sharedPreferences: sl(), uuid: sl()),
  );
  sl.registerLazySingleton<InventoryRemoteDataSource>(
    () => InventoryRemoteDataSourceImpl(dioClient: sl()),
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
