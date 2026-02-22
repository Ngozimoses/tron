import '../repositories/auth_repository.dart';
import '../entities/resident.dart';
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';

class VerifyOtp {
  final AuthRepository repository;
  VerifyOtp(this.repository);

  Future<Either<Failure, Resident>> call({required String contact, required String otp}) {
    return repository.verifyOtp(contact: contact, otp: otp);
  }
}