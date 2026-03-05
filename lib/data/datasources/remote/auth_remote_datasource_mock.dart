import 'dart:async';
import '../../../../core/constants/app_environment.dart';
import '../../../../core/errors/exceptions.dart';
import '../../models/resident_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  // Store OTP temporarily for mock verification
  static String? _storedOtp;
  static String? _storedContact;

  @override
  Future<bool> sendOtp({required String contact}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));

    // In mock mode, always "succeed"
    _storedContact = contact;
    _storedOtp = AppEnvironment.mockOtp;

    // Print for debugging
    print('🔐 [MOCK] OTP sent to $contact');
    print('🔐 [MOCK] Use OTP: ${AppEnvironment.mockOtp}');

    return true;
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({required String contact, required String otp}) async {
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));

    if (otp == AppEnvironment.mockOtp && contact == _storedContact) {
      print('🔐 [MOCK] OTP verified for $contact');

      // Return both resident and mock token
      return {
        'resident': ResidentModel.fromJson(AppEnvironment.mockResident),
        'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      };
    }

    throw ServerException(
      message: 'Invalid OTP. Use ${AppEnvironment.mockOtp} for testing',
      statusCode: 400,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _storedOtp = null;
    _storedContact = null;
    print('🔐 [MOCK] User logged out');
  }

  // Helper for tests: clear mock state
  static void clearMockData() {
    _storedOtp = null;
    _storedContact = null;
  }
}