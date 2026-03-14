import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/storage_keys.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  // PIN & Biometric
  Future<void> savePin(String pin);
  Future<void> enableBiometric();
  Future<void> disableBiometric();
  Future<bool> isPinSet();
  Future<bool> isBiometricEnabled();
  Future<bool> validatePin(String pin);

  // Onboarding
  Future<void> setOnboardingSeen();
  bool isOnboardingSeen();

  // Auth Token & Resident
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> saveResidentId(String id);
  Future<String?> getResidentId();

  // Profile Progress
  Future<void> setConnectedEstate(bool value);
  Future<bool?> hasConnectedEstate();
  Future<void> setCompletedProfile(bool value);
  Future<bool?> hasCompletedProfile();

  // ✅ NEW: KYC Status
  Future<void> setKycCompleted(bool value);
  Future<bool?> hasCompletedKyc();

  // ✅ NEW: Password Management
  Future<void> savePassword(String residentId, String password);
  Future<bool> verifyPassword(String residentId, String password);
  Future<void> clearPassword(String residentId);

  // ✅ NEW: Account Creation State
  Future<void> setAccountCreated(bool value);
  Future<bool?> isAccountCreated();
  Future<void> saveTempContact(String contact);
  Future<String?> getTempContact();

  // Cleanup
  Future<void> clearAuthData();
  Future<bool> isLoggedIn();
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

  // ==================== PIN & BIOMETRIC ====================

  @override
  Future<void> savePin(String pin) async {
    final hash = sha256.convert(utf8.encode(pin)).toString();
    await storage.write(key: StorageKeys.pinHash, value: hash);
  }

  @override
  Future<bool> validatePin(String pin) async {
    final storedHash = await storage.read(key: StorageKeys.pinHash);
    if (storedHash == null) return false;
    final inputHash = sha256.convert(utf8.encode(pin)).toString();
    return storedHash == inputHash;
  }

  @override
  Future<bool> isPinSet() async {
    final pinHash = await storage.read(key: StorageKeys.pinHash);
    return pinHash != null && pinHash.isNotEmpty;
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
  Future<bool> isBiometricEnabled() async {
    final value = await storage.read(key: StorageKeys.bioEnabled);
    return value == 'true';
  }

  // ==================== ONBOARDING ====================

  @override
  Future<void> setOnboardingSeen() async {
    await prefs.setBool(StorageKeys.onboardingSeen, true);
  }

  @override
  bool isOnboardingSeen() {
    return prefs.getBool(StorageKeys.onboardingSeen) ?? false;
  }

  // ==================== AUTH TOKEN & RESIDENT ====================

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

  // ==================== PROFILE PROGRESS ====================

  @override
  Future<void> setConnectedEstate(bool value) async {
    await prefs.setBool(StorageKeys.hasConnectedEstate, value);
  }

  @override
  Future<bool?> hasConnectedEstate() async {
    return prefs.getBool(StorageKeys.hasConnectedEstate);
  }

  @override
  Future<void> setCompletedProfile(bool value) async {
    await prefs.setBool(StorageKeys.hasCompletedProfile, value);
  }

  @override
  Future<bool?> hasCompletedProfile() async {
    return prefs.getBool(StorageKeys.hasCompletedProfile);
  }

  // ==================== ✅ KYC STATUS ====================

  @override
  Future<void> setKycCompleted(bool value) async {
    await prefs.setBool(StorageKeys.hasCompletedKyc, value);
  }

  @override
  Future<bool?> hasCompletedKyc() async {
    return prefs.getBool(StorageKeys.hasCompletedKyc);
  }

  // ==================== ✅ PASSWORD MANAGEMENT ====================

  @override
  Future<void> savePassword(String residentId, String password) async {
    // Hash password with salt for security
    final salt = _generateSalt(residentId);
    final hash = sha256.convert(utf8.encode(password + salt)).toString();
    await storage.write(key: '${StorageKeys.passwordHash}_$residentId', value: hash);
  }

  @override
  Future<bool> verifyPassword(String residentId, String password) async {
    final storedHash = await storage.read(key: '${StorageKeys.passwordHash}_$residentId');
    if (storedHash == null) return false;

    final salt = _generateSalt(residentId);
    final inputHash = sha256.convert(utf8.encode(password + salt)).toString();
    return storedHash == inputHash;
  }

  @override
  Future<void> clearPassword(String residentId) async {
    await storage.delete(key: '${StorageKeys.passwordHash}_$residentId');
  }

  // Helper: Generate deterministic salt from residentId
  String _generateSalt(String residentId) {
    final bytes = utf8.encode('qrcl_salt_${residentId}_2024');
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }

  // ==================== ✅ ACCOUNT CREATION STATE ====================

  @override
  Future<void> setAccountCreated(bool value) async {
    await prefs.setBool(StorageKeys.isAccountCreated, value);
  }

  @override
  Future<bool?> isAccountCreated() async {
    return prefs.getBool(StorageKeys.isAccountCreated);
  }

  @override
  Future<void> saveTempContact(String contact) async {
    await storage.write(key: StorageKeys.tempContact, value: contact);
  }

  @override
  Future<String?> getTempContact() async {
    return await storage.read(key: StorageKeys.tempContact);
  }

  // ==================== CLEANUP ====================

  @override
  Future<void> clearAuthData() async {
    // Secure storage
    await storage.delete(key: StorageKeys.authToken);
    await storage.delete(key: StorageKeys.residentId);
    await storage.delete(key: StorageKeys.pinHash);
    await storage.delete(key: StorageKeys.bioEnabled);
    await storage.delete(key: StorageKeys.tempContact);

    // Get residentId to clear password
    final residentId = await getResidentId();
    if (residentId != null) {
      await storage.delete(key: '${StorageKeys.passwordHash}_$residentId');
    }

    // Shared preferences
    await prefs.remove(StorageKeys.onboardingSeen);
    await prefs.remove(StorageKeys.hasConnectedEstate);
    await prefs.remove(StorageKeys.hasCompletedProfile);
    await prefs.remove(StorageKeys.hasCompletedKyc);
    await prefs.remove(StorageKeys.isAccountCreated);
  }
}