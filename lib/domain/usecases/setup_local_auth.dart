import '../repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';

class SetupLocalAuth {
  final AuthRepository repository;
  SetupLocalAuth(this.repository);

  Future<Either<Failure, bool>> call({required String pin, bool bioEnabled = false}) {
    return repository.setupLocalAuth(pin: pin, bioEnabled: bioEnabled);
  }
}