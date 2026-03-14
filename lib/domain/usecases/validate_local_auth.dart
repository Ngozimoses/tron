import '../repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

class ValidateLocalAuth {
  final AuthRepository repository;
  ValidateLocalAuth(this.repository);

  Future<Either<Failure, bool>> call({required String pin}) {
    return repository.validateLocalAuth(pin: pin);
  }
}