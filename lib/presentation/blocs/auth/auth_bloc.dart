import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../data/datasources/local/auth_local_datasource.dart';
import '../../../domain/entities/resident.dart';
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
    on<SetupPasswordEvent>(_onSetupPassword);
    on<LoginEvent>(_onLogin);
    on<SetupSecurityEvent>(_onSetupSecurity);
    on<CompleteKycEvent>(_onCompleteKyc);
    on<CheckKycStatusEvent>(_onCheckKycStatus);
    on<CheckLocalAuthEvent>(_onCheckLocalAuth);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await sendOtp(contact: event.contact);
    result.fold(
          (failure) => emit(AuthError('Failed to send OTP')),
          (_) => emit(AuthOtpSent(event.contact)),
    );
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await verifyOtp(contact: event.contact, otp: event.otp);
    result.fold(
          (failure) => emit(AuthError('Invalid OTP')),
          (resident) {
        // New account creation - save resident and require password setup
        final localDs = di.sl<AuthLocalDataSource>();
        localDs.saveResidentId(resident.id);
        localDs.setConnectedEstate(false);
        localDs.setCompletedProfile(false);
        localDs.setKycCompleted(false);
        emit(PasswordSetupRequired(resident));
      },
    );
  }

  Future<void> _onSetupPassword(SetupPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final localDs = di.sl<AuthLocalDataSource>();

      // Save password securely
      await localDs.savePassword(event.resident.id, event.password);
      await localDs.saveResidentId(event.resident.id);

      // Set onboarding flags
      await localDs.setConnectedEstate(false);
      await localDs.setCompletedProfile(false);
      await localDs.setKycCompleted(false); // KYC still incomplete

      // ✅ KEY FIX: Emit AuthAuthenticated so user goes to HOME first
      // KYC banner will show on home page (not forced redirect)
      authNotifier.setLoggedIn(true);
      emit(AuthAuthenticated());

    } catch (e) {
      emit(AuthError('Failed to setup password: $e'));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final localDs = di.sl<AuthLocalDataSource>();
      final residentId = await localDs.getResidentId();

      if (residentId == null || residentId.isEmpty) {
        emit(AuthError('Account not found. Please sign up first.'));
        return;
      }

      final isPasswordValid = await localDs.verifyPassword(residentId, event.password);
      if (!isPasswordValid) {
        emit(AuthError('Invalid email/phone or password'));
        return;
      }

      // Create minimal resident object (fetch full data from API in production)
      final resident = Resident(
        id: residentId,
        name: '',
        email: '',
        phone: '',
        blockNumber: '',
        unitNumber: '',
      );

      final kycCompleted = await localDs.hasCompletedKyc() ?? false;

      if (!kycCompleted) {
        // ✅ Emit KycRequired but router won't force redirect
        // Home page will show KYC banner instead
        emit(KycRequired(resident));
      } else {
        authNotifier.setLoggedIn(true);
        emit(AuthAuthenticated());
      }
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onSetupSecurity(SetupSecurityEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await setupLocalAuth(pin: event.pin, bioEnabled: event.bioEnabled);
    result.fold(
          (failure) => emit(AuthError('Setup Failed: ${failure.message}')),
          (_) {
        authNotifier.setLoggedIn(true);
        emit(AuthAuthenticated());
      },
    );
  }

  Future<void> _onCompleteKyc(CompleteKycEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final localDs = di.sl<AuthLocalDataSource>();
      final residentId = await localDs.getResidentId();

      if (residentId == null) {
        emit(AuthError('User not found'));
        return;
      }

      // TODO: Call API to submit KYC data in production
      // final result = await completeKycUseCase(...);

      // Mark as completed locally
      await localDs.setCompletedProfile(true);
      await localDs.setKycCompleted(true);

      authNotifier.setCompletedProfile(true);
      authNotifier.setKycCompleted(true);

      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError('KYC submission failed: $e'));
    }
  }

  Future<void> _onCheckKycStatus(CheckKycStatusEvent event, Emitter<AuthState> emit) async {
    final localDs = di.sl<AuthLocalDataSource>();
    final kycCompleted = await localDs.hasCompletedKyc() ?? false;

    if (!kycCompleted) {
      final residentId = await localDs.getResidentId();
      if (residentId != null) {
        emit(KycRequired(Resident(
          id: residentId,
          name: '',
          email: '',
          phone: '',
          blockNumber: '',
          unitNumber: '',
        )));
      }
    }
  }

  Future<void> _onCheckLocalAuth(CheckLocalAuthEvent event, Emitter<AuthState> emit) async {
    // Typically handled in Splash page
  }

  Future<void> logout() async {
    final localDataSource = di.sl<AuthLocalDataSource>();
    await localDataSource.clearAuthData();
    authNotifier.logout();
    emit(AuthInitial());
  }
}