// lib/presentation/router/auth_notifier.dart
import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart' as di;
import '../../data/datasources/local/auth_local_datasource.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = true;
  bool _hasCompletedOnboarding = false;
  bool _hasConnectedEstate = false;
  bool _hasCompletedProfile = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get hasConnectedEstate => _hasConnectedEstate;
  bool get hasCompletedProfile => _hasCompletedProfile;

  bool get shouldShowConnectEstate => isLoggedIn && !_hasConnectedEstate;
  bool get shouldShowCompleteProfile => isLoggedIn && _hasConnectedEstate && !_hasCompletedProfile;
  bool get shouldShowHome => isLoggedIn && _hasConnectedEstate && _hasCompletedProfile;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    try {
      final localDataSource = di.sl<AuthLocalDataSource>();
      _isLoggedIn = await localDataSource.isLoggedIn();

      // Check onboarding progress
      _hasConnectedEstate = await localDataSource.hasConnectedEstate() ?? false;
      _hasCompletedProfile = await localDataSource.hasCompletedProfile() ?? false;
      _hasCompletedOnboarding = _hasConnectedEstate && _hasCompletedProfile;

    } catch (e) {
      _isLoggedIn = false;
      _hasConnectedEstate = false;
      _hasCompletedProfile = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void setConnectedEstate(bool value) {
    _hasConnectedEstate = value;
    _hasCompletedOnboarding = _hasConnectedEstate && _hasCompletedProfile;
    notifyListeners();
  }

  void setCompletedProfile(bool value) {
    _hasCompletedProfile = value;
    _hasCompletedOnboarding = _hasConnectedEstate && _hasCompletedProfile;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _hasConnectedEstate = false;
    _hasCompletedProfile = false;
    _hasCompletedOnboarding = false;
    notifyListeners();
  }
}

// Create a global instance
final authNotifier = AuthNotifier();