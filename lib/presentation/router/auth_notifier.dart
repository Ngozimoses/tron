import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart' as di;
import '../../data/datasources/local/auth_local_datasource.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = true;
  bool _hasCompletedProfile = false;
  bool _hasCompletedKyc = false;

  // ✅ Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  bool get hasCompletedProfile => _hasCompletedProfile;
  bool get hasCompletedKyc => _hasCompletedKyc;

  /// Used by router
  bool get shouldShowCompleteProfile => isLoggedIn && !_hasCompletedProfile;

  /// User can access home even if KYC is not completed
  bool get canAccessHome => isLoggedIn;

  Future<void> checkAuthStatus() async {
    _isLoading = true;

    try {
      final localDataSource = di.sl<AuthLocalDataSource>();

      _isLoggedIn = await localDataSource.isLoggedIn();
      _hasCompletedProfile =
          await localDataSource.hasCompletedProfile() ?? false;
      _hasCompletedKyc =
          await localDataSource.hasCompletedKyc() ?? false;
    } catch (e) {
      _isLoggedIn = false;
      _hasCompletedProfile = false;
      _hasCompletedKyc = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Called after login or password setup
  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  /// Called when user finishes profile
  void setCompletedProfile(bool value) {
    _hasCompletedProfile = value;
    notifyListeners();
  }

  /// Called when user finishes KYC
  void setKycCompleted(bool value) {
    _hasCompletedKyc = value;
    notifyListeners();
  }

  /// Logout
  void logout() {
    _isLoggedIn = false;
    _hasCompletedProfile = false;
    _hasCompletedKyc = false;
    notifyListeners();
  }
}

/// Global instance
final authNotifier = AuthNotifier();