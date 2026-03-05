import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/storage_keys.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  Future<void> savePin(String pin);
  Future<void> enableBiometric();
  Future<void> disableBiometric();
  Future<bool> isPinSet();
  Future<bool> isBiometricEnabled();
  Future<bool> validatePin(String pin);
  Future<void> setOnboardingSeen();
  bool isOnboardingSeen();
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> saveResidentId(String id);
  Future<String?> getResidentId();
  Future<void> clearAuthData();
  Future<bool> isLoggedIn();
  Future<void> setConnectedEstate(bool value);
  Future<bool?> hasConnectedEstate();
  Future<void> setCompletedProfile(bool value);
  Future<bool?> hasCompletedProfile();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl({required this.storage, required this.prefs});
  @override
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    final residentId = await getResidentId();
    return token != null && residentId != null && token.isNotEmpty;
  }
  @override
  Future<void> savePin(String pin) async {
    final hash = sha256.convert(utf8.encode(pin)).toString();
    await storage.write(key: StorageKeys.pinHash, value: hash);
  }
  @override
  Future<void> setConnectedEstate(bool value) async {
    await prefs.setBool('has_connected_estate', value);
  }

  @override
  Future<bool?> hasConnectedEstate() async {
    return prefs.getBool('has_connected_estate');
  }

  @override
  Future<void> setCompletedProfile(bool value) async {
    await prefs.setBool('has_completed_profile', value);
  }

  @override
  Future<bool?> hasCompletedProfile() async {
    return prefs.getBool('has_completed_profile');
  }
  @override
  Future<void> enableBiometric() async {
    await storage.write(key: StorageKeys.bioEnabled, value: 'true');
  }

  @override
  Future<void> disableBiometric() async {
    await storage.write(key: StorageKeys.bioEnabled, value: 'false');
  }

  @override
  Future<bool> isPinSet() async {
    final pinHash = await storage.read(key: StorageKeys.pinHash);
    return pinHash != null && pinHash.isNotEmpty;
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final value = await storage.read(key: StorageKeys.bioEnabled);
    return value == 'true';
  }

  @override
  Future<bool> validatePin(String pin) async {
    final storedHash = await storage.read(key: StorageKeys.pinHash);
    if (storedHash == null) return false;
    final inputHash = sha256.convert(utf8.encode(pin)).toString();
    return storedHash == inputHash;
  }

  @override
  Future<void> setOnboardingSeen() async {
    await prefs.setBool(StorageKeys.onboardingSeen, true);
  }

  @override
  bool isOnboardingSeen() {
    return prefs.getBool(StorageKeys.onboardingSeen) ?? false;
  }

  @override
  Future<void> saveAuthToken(String token) async {
    await storage.write(key: StorageKeys.authToken, value: token);
  }

  @override
  Future<String?> getAuthToken() async {
    return await storage.read(key: StorageKeys.authToken);
  }

  @override
  Future<void> saveResidentId(String id) async {
    await storage.write(key: StorageKeys.residentId, value: id);
  }

  @override
  Future<String?> getResidentId() async {
    return await storage.read(key: StorageKeys.residentId);
  }

  @override
  Future<void> clearAuthData() async {
    await storage.delete(key: StorageKeys.authToken);
    await storage.delete(key: StorageKeys.residentId);
    await storage.delete(key: StorageKeys.pinHash);
    await storage.delete(key: StorageKeys.bioEnabled);
    await prefs.remove(StorageKeys.onboardingSeen);
  }
}