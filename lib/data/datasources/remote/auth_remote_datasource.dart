import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/resident_model.dart';
// In auth_remote_datasource.dart
abstract class AuthRemoteDataSource {
  Future<bool> sendOtp({required String contact});
  Future<Map<String, dynamic>> verifyOtp({required String contact, required String otp}); // Changed return type
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<bool> sendOtp({required String contact}) async {
    try {
      final response = await client.post(
        ApiConstants.sendOtp,
        data: {'contact': contact},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Failed to send OTP',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Failed to send OTP: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({required String contact, required String otp}) async {
    try {
      final response = await client.post(
        ApiConstants.verifyOtp,
        data: {'contact': contact, 'otp': otp},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ Return both resident and token
        return {
          'resident': ResidentModel.fromJson(response.data['resident']),
          'token': response.data['token'] ?? 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        };
      }

      throw ServerException(
        message: response.data['message'] ?? 'Failed to verify OTP',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Failed to verify OTP',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Failed to verify OTP: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await client.post('auth/logout');
    } catch (e) {
      // Log out even if server call fails
    }
  }
}