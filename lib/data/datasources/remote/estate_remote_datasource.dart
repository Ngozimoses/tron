import 'package:dio/dio.dart';
import 'package:tron/core/di/injection_container.dart' as di;
import 'package:tron/core/errors/exceptions.dart';
import 'package:tron/data/datasources/local/secure_storage_impl.dart';
import '../../../core/constants/api_constants.dart.dart';
import '../../models/resident_model.dart';

abstract class EstateRemoteDataSource {
  Future<ResidentModel> getResidentProfile(String residentId);
  Future<List<dynamic>> getEstateNotices();
  Future<List<dynamic>> getMaintenanceRequests();
  Future<bool> submitMaintenanceRequest(Map<String, dynamic> request);
  Future<bool> submitComplaint(Map<String, dynamic> complaint);
  Future<List<dynamic>> getPaymentHistory();
  Future<bool> makePayment(Map<String, dynamic> payment);
  Future<List<dynamic>> getVisitors();
  Future<bool> approveVisitor(String visitorId);
  Future<bool> rejectVisitor(String visitorId);
  Future<List<dynamic>> getResidentEvents(String residentId);
}

class EstateRemoteDataSourceImpl implements EstateRemoteDataSource {
  final Dio client;

  EstateRemoteDataSourceImpl({required this.client});

  @override
  Future<ResidentModel> getResidentProfile(String residentId) async {
    try {
      final response = await client.get('${ApiConstants.residentProfile}$residentId');
      if (response.statusCode == 200) {
        return ResidentModel.fromJson(response.data['resident']);
      }
      throw ServerException(
        message: 'Failed to fetch profile',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<dynamic>> getEstateNotices() async {
    try {
      final response = await client.get(ApiConstants.notices);
      if (response.statusCode == 200) {
        return response.data['notices'] ?? [];
      }
      throw ServerException(
        message: 'Failed to fetch notices',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<dynamic>> getMaintenanceRequests() async {
    try {
      final response = await client.get(ApiConstants.maintenance);
      if (response.statusCode == 200) {
        return response.data['requests'] ?? [];
      }
      throw ServerException(
        message: 'Failed to fetch maintenance requests',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> submitMaintenanceRequest(Map<String, dynamic> request) async {
    try {
      final response = await client.post(ApiConstants.maintenance, data: request);
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> submitComplaint(Map<String, dynamic> complaint) async {
    try {
      final response = await client.post(ApiConstants.complaints, data: complaint);
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<dynamic>> getPaymentHistory() async {
    try {
      final response = await client.get(ApiConstants.payments);
      if (response.statusCode == 200) {
        return response.data['payments'] ?? [];
      }
      throw ServerException(
        message: 'Failed to fetch payments',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> makePayment(Map<String, dynamic> payment) async {
    try {
      final response = await client.post(ApiConstants.payments, data: payment);
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<dynamic>> getVisitors() async {
    try {
      final response = await client.get(ApiConstants.visitors);
      if (response.statusCode == 200) {
        return response.data['visitors'] ?? [];
      }
      throw ServerException(
        message: 'Failed to fetch visitors',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> approveVisitor(String visitorId) async {
    try {
      final response = await client.put('${ApiConstants.visitors}/$visitorId/approve');
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> rejectVisitor(String visitorId) async {
    try {
      final response = await client.put('${ApiConstants.visitors}/$visitorId/reject');
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<dynamic>> getResidentEvents(String residentId) async {
    try {
      final response = await client.get(
        '${ApiConstants.residentProfile}$residentId/events',
        options: Options(
          headers: {'Authorization': 'Bearer ${await _getAuthToken()}'},
        ),
      );

      if (response.statusCode == 200) {
        return List<dynamic>.from(response.data['events'] ?? []);
      }
      throw ServerException(
        message: 'Failed to fetch events',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      // Return empty list for 404 (no events) instead of throwing
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  // Helper: Get auth token from secure storage
  Future<String?> _getAuthToken() async {
    try {
      return await di.sl<SecureStorageImpl>().getAuthToken();
    } catch (_) {
      return null;
    }
  }
}