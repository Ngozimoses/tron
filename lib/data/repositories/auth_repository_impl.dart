import '../../core/errors/exceptions.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../../domain/entities/resident.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/network_info.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> sendOtp({required String contact}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await remoteDataSource.sendOtp(contact: contact);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Resident>> verifyOtp({required String contact, required String otp}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await remoteDataSource.verifyOtp(contact: contact, otp: otp);

      // ✅ Save both resident ID and auth token
      final resident = result['resident'] as Resident;
      final token = result['token'] as String;

      await localDataSource.saveResidentId(resident.id);
      await localDataSource.saveAuthToken(token); // Make sure this method exists

      return Right(resident);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  @override
  Future<Either<Failure, bool>> setupLocalAuth({required String pin, bool bioEnabled = false}) async {
    try {
      await localDataSource.savePin(pin);
      if (bioEnabled) {
        await localDataSource.enableBiometric();
      }
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validateLocalAuth({required String pin}) async {
    try {
      final isValid = await localDataSource.validatePin(pin);
      return Right(isValid);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isSecuritySetup() async {
    return await localDataSource.isPinSet();
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return await localDataSource.isBiometricEnabled();
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearAuthData();
      return const Right(null);
    } catch (e) {
      // Still clear local data even if server call fails
      await localDataSource.clearAuthData();
      return const Right(null);
    }
  }
}