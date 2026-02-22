import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../data/datasources/local/auth_local_datasource.dart';
import '../../../data/datasources/local/secure_storage_impl.dart';
import '../../widgets/biometric_prompt.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Small delay for splash animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      // ✅ Safe: Dependencies are now ready after sl.allReady()
      final localDs = di.sl<AuthLocalDataSource>();
      final secureStorage = di.sl<SecureStorageImpl>();

      // Check if onboarding is seen
      if (!localDs.isOnboardingSeen()) {
        context.go('/onboarding');
        return;
      }

      // Check if security is setup
      final isSecuritySetup = await localDs.isPinSet();

      if (isSecuritySetup) {
        final isBioEnabled = await secureStorage.isBiometricEnabled();

        if (isBioEnabled) {
          final biometricPrompt = BiometricPrompt();
          final authenticated = await biometricPrompt.authenticate('Authenticate to access Estate App');

          if (authenticated && mounted) {
            context.go('/home');
            return;
          }
        }

        if (mounted) {
          context.go('/home');
        }
      } else {
        context.go('/identify');
      }
    } catch (e) {
      // ✅ Fallback: If DI fails, go to identify page
      if (mounted) {
        context.go('/identify');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(
                Icons.qr_code_scanner,
                size: 29.17,
                color: Colors.white,
              ),
                const SizedBox(width: 10),
                Text(
                  'QR CODE',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),],)
              ,
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      )
    );
  }
}