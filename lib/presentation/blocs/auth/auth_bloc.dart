import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../data/datasources/local/auth_local_datasource.dart';
import '../../../domain/usecases/send_otp.dart';
import '../../../domain/usecases/verify_otp.dart';
import '../../../domain/usecases/setup_local_auth.dart';
import '../../../domain/usecases/validate_local_auth.dart';
import '../../router/app_router.dart';
import '../../router/auth_notifier.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtp sendOtp;
  final VerifyOtp verifyOtp;
  final SetupLocalAuth setupLocalAuth;
  final ValidateLocalAuth validateLocalAuth;

  AuthBloc({
    required this.sendOtp,
    required this.verifyOtp,
    required this.setupLocalAuth,
    required this.validateLocalAuth,
  }) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<SetupSecurityEvent>(_onSetupSecurity);
    on<CheckLocalAuthEvent>(_onCheckLocalAuth);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await sendOtp(contact: event.contact);
    result.fold(
      // ✅ FIX: Use AuthOtpSent instead of AuthSuccess
          (failure) => emit(AuthError('Failed to send OTP')),
          (_) => emit(AuthOtpSent(event.contact)),
    );
  }

// In auth_bloc.dart - Update _onVerifyOtp
  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await verifyOtp(contact: event.contact, otp: event.otp);
    result.fold(
          (failure) => emit(AuthError('Invalid OTP')),
          (resident) {
        // Don't set logged in yet - still need security setup
        // But we can pre-set the onboarding flags to false
        final localDs = di.sl<AuthLocalDataSource>();
        localDs.setConnectedEstate(false);
        localDs.setCompletedProfile(false);

        emit(SecuritySetupRequired(resident));
      },
    );
  }

  Future<void> _onSetupSecurity(SetupSecurityEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await setupLocalAuth(pin: event.pin, bioEnabled: event.bioEnabled);
    result.fold(
          (failure) => emit(AuthError('Setup Failed: ${failure.message}')),
          (_) {
        // Update auth notifier
        authNotifier.setLoggedIn(true);
        emit(AuthAuthenticated());
      },
    );
  }

// Add logout method
  Future<void> logout() async {
    // Clear local data
    final localDataSource = di.sl<AuthLocalDataSource>();
    await localDataSource.clearAuthData();

    // Update auth notifier
    authNotifier.logout();
  }
  Future<void> _onCheckLocalAuth(CheckLocalAuthEvent event, Emitter<AuthState> emit) async {
    // Logic to check local storage handled in Splash Page usually,
    // but can be triggered here for re-validation
  }
}