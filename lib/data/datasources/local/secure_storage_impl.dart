import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/constants/storage_keys.dart';

abstract class SecureStorageService {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();
  Future<Map<String, String>> readAll();
}

class SecureStorageImpl implements SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageImpl({required FlutterSecureStorage storage}) : _storage = storage;

  @override
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  @override
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll() ?? {};
  }

  // Specific methods for estate app
  Future<void> saveAuthToken(String token) async {
    await write(key: StorageKeys.authToken, value: token);
  }

  Future<String?> getAuthToken() async {
    return await read(key: StorageKeys.authToken);
  }

  Future<void> saveResidentId(String id) async {
    await write(key: StorageKeys.residentId, value: id);
  }

  Future<String?> getResidentId() async {
    return await read(key: StorageKeys.residentId);
  }

  Future<bool> isBiometricEnabled() async {
    final value = await read(key: StorageKeys.bioEnabled);
    return value == 'true';
  }

  Future<void> saveFcmToken(String token) async {
    await write(key: StorageKeys.fcmToken, value: token);
  }

  Future<String?> getFcmToken() async {
    return await read(key: StorageKeys.fcmToken);
  }
}