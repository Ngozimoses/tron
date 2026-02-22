import '../repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';

class SendOtp {
  final AuthRepository repository;
  SendOtp(this.repository);

  Future<Either<Failure, bool>> call({required String contact}) {
    return repository.sendOtp(contact: contact);
  }
}