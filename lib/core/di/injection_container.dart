import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/local/secure_storage_impl.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/estate_remote_datasource.dart';
// ✅ Import mock data sources
import '../../data/datasources/remote/auth_remote_datasource_mock.dart';
import '../../data/datasources/remote/estate_remote_datasource_mock.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/usecases/setup_local_auth.dart';
import '../../domain/usecases/validate_local_auth.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/onboarding/onboarding_bloc.dart';
import '../../presentation/blocs/home/home_bloc.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
// ✅ Import environment config
import '../constants/app_environment.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ========================================
  // STEP 1: Register EXTERNAL dependencies
  // ========================================

  sl.registerLazySingleton(() => ApiClient().dio);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // ========================================
  // STEP 2: Register NETWORK layer
  // ========================================

  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(connectionChecker: sl()),
  );

  // ========================================
  // STEP 3: Register DATA SOURCES (Mock or Real)
  // ========================================

  // ✅ Choose mock or real based on environment flag
  if (AppEnvironment.isDevelopment) {
    // 🧪 MOCK MODE: Use mock data sources
    print('🧪 [DI] Using MOCK data sources for development');

    sl.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceMock(),
    );
    sl.registerLazySingleton<EstateRemoteDataSource>(
          () => EstateRemoteDataSourceMock(),
    );
  } else {
    // 🌐 PRODUCTION MODE: Use real API
    print('🌐 [DI] Using REAL API data sources for production');

    sl.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(client: sl()),
    );
    sl.registerLazySingleton<EstateRemoteDataSource>(
          () => EstateRemoteDataSourceImpl(client: sl()),
    );
  }

  // Local data sources (same for both modes)
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(storage: sl(), prefs: sl()),
  );
  sl.registerLazySingleton<SecureStorageImpl>(
        () => SecureStorageImpl(storage: sl()),
  );

  // ========================================
  // STEP 4: Register REPOSITORY
  // ========================================

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ========================================
  // STEP 5: Register USE CASES
  // ========================================

  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => SetupLocalAuth(sl()));
  sl.registerLazySingleton(() => ValidateLocalAuth(sl()));

  // ========================================
  // STEP 6: Register BLoCs
  // ========================================

  sl.registerFactory(() => AuthBloc(
    verifyOtp: sl(),
    setupLocalAuth: sl(),
    validateLocalAuth: sl(),
    sendOtp: sl(),
  ));

  sl.registerFactory(() => OnboardingBloc(localDataSource: sl()));

  sl.registerFactory(() => HomeBloc(
    remoteDataSource: sl(),
    localDataSource: sl(),
  ));

  // ========================================
  // STEP 7: Signal ready
  // ========================================

  await sl.allReady();

  // ✅ Print environment info for debugging
  print('✅ [DI] Dependency injection initialized');
  print('🔧 Environment: ${AppEnvironment.isDevelopment ? 'DEVELOPMENT (Mock)' : 'PRODUCTION (Real API)'}');
}


// import 'package:get_it/get_it.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import '../../data/datasources/local/auth_local_datasource.dart';
// import '../../data/datasources/local/secure_storage_impl.dart';
// import '../../data/datasources/remote/auth_remote_datasource.dart';
// import '../../data/datasources/remote/estate_remote_datasource.dart';
// import '../../data/repositories/auth_repository_impl.dart';
// import '../../domain/repositories/auth_repository.dart';
// import '../../domain/usecases/send_otp.dart';
// import '../../domain/usecases/verify_otp.dart';
// import '../../domain/usecases/setup_local_auth.dart';
// import '../../domain/usecases/validate_local_auth.dart';
// import '../../presentation/blocs/auth/auth_bloc.dart';
// import '../../presentation/blocs/onboarding/onboarding_bloc.dart';
// import '../../presentation/blocs/home/home_bloc.dart';
// import '../network/api_client.dart';
// import '../network/network_info.dart';
//
// final sl = GetIt.instance;
//
// Future<void> init() async {
//   // ========================================
//   // STEP 1: Register EXTERNAL dependencies first (sync)
//   // ========================================
//
//   // Dio HTTP client
//   sl.registerLazySingleton(() => ApiClient().dio);
//
//   // FlutterSecureStorage (has const constructor)
//   sl.registerLazySingleton(() => const FlutterSecureStorage());
//
//   // InternetConnectionChecker (use singleton instance)
//   sl.registerLazySingleton(() => InternetConnectionChecker.instance);
//
//   // SharedPreferences - ⚠️ ASYNC: Initialize NOW and register sync
//   final prefs = await SharedPreferences.getInstance();
//   sl.registerLazySingleton<SharedPreferences>(() => prefs);
//
//   // ========================================
//   // STEP 2: Register NETWORK layer
//   // ========================================
//
//   sl.registerLazySingleton<NetworkInfo>(
//         () => NetworkInfoImpl(connectionChecker: sl()),
//   );
//
//   // ========================================
//   // STEP 3: Register DATA SOURCES
//   // ========================================
//
//   // Remote data sources
//   sl.registerLazySingleton<AuthRemoteDataSource>(
//         () => AuthRemoteDataSourceImpl(client: sl()),
//   );
//   sl.registerLazySingleton<EstateRemoteDataSource>(
//         () => EstateRemoteDataSourceImpl(client: sl()),
//   );
//
//   // Local data sources (now SharedPreferences is ready!)
//   sl.registerLazySingleton<AuthLocalDataSource>(
//         () => AuthLocalDataSourceImpl(storage: sl(), prefs: sl()),
//   );
//   sl.registerLazySingleton<SecureStorageImpl>(
//         () => SecureStorageImpl(storage: sl()),
//   );
//
//   // ========================================
//   // STEP 4: Register REPOSITORY
//   // ========================================
//
//   sl.registerLazySingleton<AuthRepository>(
//         () => AuthRepositoryImpl(
//       remoteDataSource: sl(),
//       localDataSource: sl(),
//       networkInfo: sl(), // ✅ Now registered and ready
//     ),
//   );
//
//   // ========================================
//   // STEP 5: Register USE CASES
//   // ========================================
//
//   sl.registerLazySingleton(() => SendOtp(sl()));
//   sl.registerLazySingleton(() => VerifyOtp(sl()));
//   sl.registerLazySingleton(() => SetupLocalAuth(sl()));
//   sl.registerLazySingleton(() => ValidateLocalAuth(sl()));
//
//   // ========================================
//   // STEP 6: Register BLoCs (last - they depend on use cases)
//   // ========================================
//
//   sl.registerFactory(() => AuthBloc(
//     verifyOtp: sl(),
//     setupLocalAuth: sl(),
//     validateLocalAuth: sl(),
//     sendOtp: sl(),
//   ));
//
//   sl.registerFactory(() => OnboardingBloc(localDataSource: sl()));
//
//   sl.registerFactory(() => HomeBloc(
//     remoteDataSource: sl(),
//     localDataSource: sl(),
//   ));
//
//   // ========================================
//   // STEP 7: Signal all async registrations are complete
//   // ========================================
//
//   // ✅ Critical: Wait for all async registrations to complete
//   await sl.allReady();
// }