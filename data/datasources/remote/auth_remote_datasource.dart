import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/resident_model.dart';

abstract class AuthRemoteDataSource {
  Future<bool> sendOtp({required String contact});
  Future<ResidentModel> verifyOtp({required String contact, required String otp});
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
  Future<ResidentModel> verifyOtp({required String contact, required String otp}) async {
    try {
      final response = await client.post(
        ApiConstants.verifyOtp,
        data: {'contact': contact, 'otp': otp},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResidentModel.fromJson(response.data['resident']);
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