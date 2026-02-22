class ApiConstants {
  static const String baseUrl = 'https://api.estate-management.com/v1/';
  static const String sendOtp = 'auth/send-otp';
  static const String verifyOtp = 'auth/verify-otp';
  static const String residentProfile = 'residents/';
  static const String notices = 'notices';
  static const String maintenance = 'maintenance';
  static const String complaints = 'complaints';
  static const String payments = 'payments';
  static const String visitors = 'visitors';

  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
}