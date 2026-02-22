// lib/presentation/pages/settings/notification_settings_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _visitorEntryAlerts = false;
  bool _qrExpiryAlerts = false;
  bool _qrRevokedAlerts = false;
  bool _generalAppUpdates = false;
  bool _enableSounds = false;
  bool _vibration = false;

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
          'Notification Settings',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'A unique QR code will be generated for your visitor. The code expires automatically',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Visitor Activity Section
            _buildSectionHeader('Visitor Activity'),
            const SizedBox(height: 8),
            _buildNotificationCard([
              _buildNotificationTile(
                title: 'Visitor Entry Alerts',
                subtitle: 'Notify me when a visitor enters',
                value: _visitorEntryAlerts,
                onChanged: (value) {
                  setState(() {
                    _visitorEntryAlerts = value;
                  });
                },
              ),
              _buildNotificationTile(
                title: 'QR Expiry Alerts',
                subtitle: 'Notify me when a QR is about to expire',
                value: _qrExpiryAlerts,
                onChanged: (value) {
                  setState(() {
                    _qrExpiryAlerts = value;
                  });
                },
              ),
              _buildNotificationTile(
                title: 'QR Revoked Alerts',
                subtitle: 'Alerts for revoked or cancelled passes',
                value: _qrRevokedAlerts,
                onChanged: (value) {
                  setState(() {
                    _qrRevokedAlerts = value;
                  });
                },
              ),
            ]),
            const SizedBox(height: 24),

            // App Notification Section
            _buildSectionHeader('App Notification'),
            const SizedBox(height: 8),
            _buildNotificationCard([
              _buildNotificationTile(
                title: 'General App Updates',
                subtitle: 'New features, improvements',
                value: _generalAppUpdates,
                onChanged: (value) {
                  setState(() {
                    _generalAppUpdates = value;
                  });
                },
              ),
              _buildNotificationTile(
                title: 'Enable Sounds',
                subtitle: 'Play a sound for incoming alerts',
                value: _enableSounds,
                onChanged: (value) {
                  setState(() {
                    _enableSounds = value;
                  });
                },
              ),
              _buildNotificationTile(
                title: 'Vibration',
                subtitle: 'Vibrate for incoming alerts',
                value: _vibration,
                onChanged: (value) {
                  setState(() {
                    _vibration = value;
                  });
                },
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

  Widget _buildNotificationCard(List<Widget> children) {
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

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
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
}