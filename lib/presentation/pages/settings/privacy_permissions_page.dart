// lib/presentation/pages/settings/privacy_permissions_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_colors.dart';

class PrivacyPermissionsPage extends StatefulWidget {
  const PrivacyPermissionsPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPermissionsPage> createState() => _PrivacyPermissionsPageState();
}

class _PrivacyPermissionsPageState extends State<PrivacyPermissionsPage> {
  bool _cameraAccess = false;
  bool _pushNotifications = false;
  bool _backgroundRefresh = false;
  bool _locationAccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading:GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(

              decoration: BoxDecoration(
                color: Color.fromRGBO(156, 163, 175, 1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios, size: 12, color: Colors.white),
            ),
          ),
        ),
        title: const Text(
          'Privacy & Permissions',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Permission Section
            _buildSectionHeader('Permission'),
            const SizedBox(height: 8),
            _buildPermissionCard([
              _buildPermissionTile(
                title: 'Camera Access',
                value: _cameraAccess,
                onChanged: (value) async {
                  if (value) {
                    final status = await Permission.camera.request();
                    setState(() {
                      _cameraAccess = status.isGranted;
                    });
                  } else {
                    // await Permission.camera.deny();
                    // setState(() {
                    //   _cameraAccess = false;
                    // });
                  }
                },
              ),
              _buildPermissionTile(
                title: 'Push Notifications',
                value: _pushNotifications,
                onChanged: (value) async {
                  if (value) {
                    final status = await Permission.notification.request();
                    setState(() {
                      _pushNotifications = status.isGranted;
                    });
                  } else {
                    // await Permission.notification.deny();
                    // setState(() {
                    //   _pushNotifications = false;
                    // });
                  }
                },
              ),
              _buildPermissionTile(
                title: 'Background Refresh',
                value: _backgroundRefresh,
                onChanged: (value) {
                  setState(() {
                    _backgroundRefresh = value;
                  });
                },
              ),
              _buildPermissionTile(
                title: 'Location Access (Optional)',
                value: _locationAccess,
                onChanged: (value) async {
                  if (value) {
                    final status = await Permission.location.request();
                    setState(() {
                      _locationAccess = status.isGranted;
                    });
                  } else {
                    // await Permission.location.deny();
                    // setState(() {
                    //   _locationAccess = false;
                    // });
                  }
                },
              ),
            ]),
            const SizedBox(height: 24),

            // Data & Security Section
            _buildSectionHeader('Data & Security'),
            const SizedBox(height: 8),
            _buildPermissionCard([
              _buildMenuItem(
                icon: Icons.security,
                title: 'Manage Personal Data',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.description,
                title: 'Terms of Use',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                onTap: () {},
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPermissionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildPermissionTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.divider),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}