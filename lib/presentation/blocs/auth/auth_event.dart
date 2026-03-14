import 'package:equatable/equatable.dart';

import '../../../domain/entities/resident.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String contact;
  SendOtpEvent(this.contact);
  @override
  List<Object?> get props => [contact];
}

// ✅ NEW: Event for resending OTP
class ResendOtpEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class VerifyOtpEvent extends AuthEvent {
  final String contact;
  final String otp;
  VerifyOtpEvent(this.contact, this.otp);
  @override
  List<Object?> get props => [contact, otp];
}

class SetupSecurityEvent extends AuthEvent {
  final String pin;
  final bool bioEnabled;
  SetupSecurityEvent(this.pin, this.bioEnabled);
  @override
  List<Object?> get props => [pin, bioEnabled];
}
// Add these events to auth_event.dart

class SetupPasswordEvent extends AuthEvent {
  final String password;
  final Resident resident;
  SetupPasswordEvent(this.password, this.resident);
  @override
  List<Object?> get props => [password, resident];
}

class LoginEvent extends AuthEvent {
  final String contact;
  final String password;
  LoginEvent(this.contact, this.password);
  @override
  List<Object?> get props => [contact, password];
}

class CompleteKycEvent extends AuthEvent {
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? profileImage;final String? estateId;
  CompleteKycEvent({
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.profileImage, this.estateId,
  });
  @override
  List<Object?> get props => [fullName, phoneNumber, email, profileImage,estateId];
}

class CheckKycStatusEvent extends AuthEvent {}

class CheckLocalAuthEvent extends AuthEvent {}