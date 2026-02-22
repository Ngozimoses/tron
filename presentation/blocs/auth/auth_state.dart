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

class AuthAuthenticated extends AuthState {}