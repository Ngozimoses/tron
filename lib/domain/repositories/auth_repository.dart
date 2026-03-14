import '../../core/errors/failures.dart';
import '../entities/resident.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> sendOtp({required String contact});
  Future<Either<Failure, Resident>> verifyOtp({required String contact, required String otp});
  Future<Either<Failure, bool>> setupLocalAuth({required String pin, bool bioEnabled = false});
  Future<Either<Failure, bool>> validateLocalAuth({required String pin});
  Future<bool> isSecuritySetup();
  Future<bool> isBiometricEnabled();
  Future<Either<Failure, void>> logout();
}