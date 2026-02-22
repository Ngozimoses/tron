import 'package:equatable/equatable.dart';

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

class CheckLocalAuthEvent extends AuthEvent {}