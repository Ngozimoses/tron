import 'dart:async';
import 'package:tron/core/constants/app_environment.dart';
import '../../../../core/errors/exceptions.dart';
import '../../models/resident_model.dart';
import 'estate_remote_datasource.dart';

class EstateRemoteDataSourceMock implements EstateRemoteDataSource {
  @override
  Future<ResidentModel> getResidentProfile(String residentId) async {
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));
    return ResidentModel.fromJson(AppEnvironment.mockResident);
  }

  @override
  Future<List<dynamic>> getEstateNotices() async {
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));
    return [
      {
        'id': 'not_001',
        'title': 'Welcome to Alaska Estate',
        'description': 'Your secure community living starts here. Explore all features.',
        'priority': 'info',
        'category': 'announcement',
        'created_at': DateTime.now().toIso8601String(),
        'expires_at': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        'is_read': false,
      },
      {
        'id': 'not_002',
        'title': 'Security Update',
        'description': 'We\'ve enhanced our biometric authentication for better protection.',
        'priority': 'high',
        'category': 'security',
        'created_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'expires_at': null,
        'is_read': false,
      },
    ];
  }

  @override
  Future<List<dynamic>> getMaintenanceRequests() async {
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));
    return [
      {
        'id': 'mnt_001',
        'title': 'Pool Maintenance',
        'description': 'Regular cleaning scheduled for this weekend',
        'status': 'scheduled',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];
  }

  @override
  Future<bool> submitMaintenanceRequest(Map<String, dynamic> request) async {
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));
    print('🔧 [MOCK] Maintenance request submitted: ${request['title']}');
    return true;
  }

  @override
  Future<bool> submitComplaint(Map<String, dynamic> complaint) async {
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));
    print('⚠️ [MOCK] Complaint submitted: ${complaint['title']}');
    return true;
  }

  @override
  Future<List<dynamic>> getPaymentHistory() async {
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));
    return [
      {
        'id': 'pay_001',
        'amount': 50000,
        'currency': 'NGN',
        'type': 'rent',
        'period': '2024-02',
        'status': 'completed',
        'paid_at': '2024-02-01T09:00:00Z',
      },
    ];
  }

  @override
  Future<bool> makePayment(Map<String, dynamic> payment) async {
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));
    print('💳 [MOCK] Payment processed: ${payment['amount']} ${payment['currency']}');
    return true;
  }

  @override
  Future<List<dynamic>> getVisitors() async {
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));
    return [
      {
        'id': 'vis_001',
        'name': 'John Visitor',
        'phone': '+2348099998888',
        'purpose': 'Family Visit',
        'expected_arrival': DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
        'status': 'pending',
        'resident_id': 'res_mock_001',
      },
    ];
  }

  @override
  Future<bool> approveVisitor(String visitorId) async {
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));
    print('👥 [MOCK] Visitor approved: $visitorId');
    return true;
  }

  @override
  Future<bool> rejectVisitor(String visitorId) async {
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));
    print('👥 [MOCK] Visitor rejected: $visitorId');
    return true;
  }

  @override
  Future<List<dynamic>> getResidentEvents(String residentId) async {
    await Future.delayed(const Duration(milliseconds: AppEnvironment.mockApiDelay));

    final now = DateTime.now();
    return [
      {
        'id': 'evt_001',
        'name': 'Community BBQ',
        'hosted_by': 'Estate Management',
        'date': now.add(const Duration(days: 2)).toIso8601String(),
        'avatar': null,
        'description': 'Join us for a fun community gathering with food and music!',
        'location': 'Main Garden',
        'category': 'social',
      },
      {
        'id': 'evt_002',
        'name': 'Security Drill',
        'hosted_by': 'Security Team',
        'date': now.subtract(const Duration(days: 1)).toIso8601String(),
        'avatar': null,
        'description': 'Mandatory safety exercise for all residents.',
        'location': 'Estate Grounds',
        'category': 'security',
      },
      {
        'id': 'evt_003',
        'name': 'Town Hall Meeting',
        'hosted_by': 'Admin',
        'date': now.toIso8601String(),
        'avatar': null,
        'description': 'Monthly update on estate improvements and Q&A session.',
        'location': 'Community Hall',
        'category': 'meeting',
      },
      {
        'id': 'evt_004',
        'name': 'Pool Maintenance',
        'hosted_by': 'Facilities Team',
        'date': now.add(const Duration(days: 5)).toIso8601String(),
        'avatar': null,
        'description': 'Pool will be closed for routine maintenance.',
        'location': 'Swimming Pool',
        'category': 'maintenance',
      },
    ];
  }
}