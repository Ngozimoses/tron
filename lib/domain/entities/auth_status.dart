import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  unauthenticated,
  identifying,
  otpSent,
  otpVerified,
  securitySetupRequired,
  authenticated,
  error,
}

class AuthStatusEntity extends Equatable {
  final AuthStatus status;
  final String? message;
  final String? contact;
  final bool? isBiometricEnabled;
  final DateTime? otpExpiry;

  const AuthStatusEntity({
    required this.status,
    this.message,
    this.contact,
    this.isBiometricEnabled,
    this.otpExpiry,
  });

  @override
  List<Object?> get props => [status, message, contact, isBiometricEnabled, otpExpiry];

  AuthStatusEntity copyWith({
    AuthStatus? status,
    String? message,
    String? contact,
    bool? isBiometricEnabled,
    DateTime? otpExpiry,
  }) {
    return AuthStatusEntity(
      status: status ?? this.status,
      message: message ?? this.message,
      contact: contact ?? this.contact,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      otpExpiry: otpExpiry ?? this.otpExpiry,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isSecuritySetupRequired => status == AuthStatus.securitySetupRequired;
  bool get isLoading => status == AuthStatus.identifying || status == AuthStatus.otpSent;
}