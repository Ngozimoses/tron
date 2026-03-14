import 'package:equatable/equatable.dart';
import '../../../domain/entities/resident.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// ✅ NEW: State for when OTP is sent successfully
class AuthOtpSent extends AuthState {
  final String contact;
  AuthOtpSent(this.contact);
  @override
  List<Object?> get props => [contact];
}

class AuthSuccess extends AuthState {
  final Resident resident;
  AuthSuccess(this.resident);
  @override
  List<Object?> get props => [resident];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class SecuritySetupRequired extends AuthState {
  final Resident resident;
  SecuritySetupRequired(this.resident);
  @override
  List<Object?> get props => [resident];
}
// Add these states to auth_state.dart

class PasswordSetupRequired extends AuthState {
  final Resident resident;
  PasswordSetupRequired(this.resident);
  @override
  List<Object?> get props => [resident];
}

class KycRequired extends AuthState {
  final Resident resident;
  KycRequired(this.resident);
  @override
  List<Object?> get props => [resident];
}

class KycPending extends AuthState {
  final Resident resident;
  KycPending(this.resident);
  @override
  List<Object?> get props => [resident];
}

class LoginRequired extends AuthState {}

class AuthAuthenticated extends AuthState {}