class AppEnvironment {
  // ✅ Toggle this to switch between mock and real API
  static const bool isDevelopment = true; // ← Set to false for production

  // API Base URL (only used when isDevelopment = false)
  static const String apiUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.estate-management.com/v1/',
  );

  // Mock delay to simulate network latency (in milliseconds)
  static const int mockApiDelay = 1500;

  // Mock resident data for testing
  static const Map<String, dynamic> mockResident = {
    'id': 'res_mock_001',
    'name': 'Test Resident',
    'email': 'test@alaskaestate.com',
    'phone': '+2348012345678',
    'block_number': 'A',
    'unit_number': '101',
    'profile_image': null,
    'move_in_date': '2024-01-15T00:00:00Z',
    'is_owner': true,
  };

  // Mock OTP (for testing, any 4-digit code works)
  static const String mockOtp = '1234';
}