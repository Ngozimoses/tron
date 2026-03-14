import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricPrompt {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> isSupported() async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticate(String reason) async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        return false;
      }

      final List<BiometricType> availableBiometrics =
      await _localAuth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        return false;
      }

      // ✅ CORRECT: Use AuthenticationOptions with biometricOnly parameter
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          biometricOnly: true,  // This replaces the authenticators parameter
          stickyAuth: true,     // Keep the session alive after app suspend
        ),
      );
    } on PlatformException catch (e) {
      // Handle specific platform errors
      if (e.code == 'NotEnrolled') {
        print('User hasn\'t enrolled any biometrics');
        return false;
      } else if (e.code == 'NotAvailable') {
        print('Biometric hardware not available');
        return false;
      } else if (e.code == 'PasscodeNotSet') {
        print('No device passcode set');
        return false;
      } else if (e.code == 'AppCancel') {
        print('User canceled authentication');
        return false;
      } else if (e.code == 'LockedOut') {
        print('Too many attempts - biometrics locked out');
        return false;
      }
      print('Platform error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('General error: $e');
      return false;
    }
  }

  Future<bool> canUseBiometric() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  // ✅ Alternative method with more options
  Future<bool> authenticateWithOptions({
    required String reason,
    bool biometricOnly = true,
    bool stickyAuth = true,
    bool useErrorDialogs = true,
  }) async {
    try {
      final availableBiometrics = await getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: stickyAuth,
          useErrorDialogs: useErrorDialogs,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // ✅ Method to stop authentication
  Future<void> stopAuthentication() async {
    await _localAuth.stopAuthentication();
  }
}