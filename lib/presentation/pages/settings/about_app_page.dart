// lib/presentation/pages/settings/about_app_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/theme/app_colors.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  String _appVersion = '';
  String _lastUpdated = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
        _lastUpdated = packageInfo.buildNumber; // Or use a formatted date
      });
    } catch (e) {
      setState(() {
        _appVersion = '1.0.0';
        _lastUpdated = '2024';
      });
    }
  }

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
          'About the App',
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  _buildInfoRow('App Version', _appVersion.isEmpty ? 'Loading...' : _appVersion),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildInfoRow('Last Updated', _lastUpdated.isEmpty ? 'Loading...' : _lastUpdated),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildMenuItem(
                    title: 'About QRCode.ng',
                    onTap: () => context.push('/settings/about-qrcl'),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildMenuItem(
                    title: 'Terms & Conditions',
                    onTap: () => context.push('/settings/terms-conditions'),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildMenuItem(
                    title: 'Privacy Policy',
                    onTap: () => context.push('/settings/privacy-policy'),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildMenuItem(
                    title: 'Open Source Licenses',
                    onTap: () {
                      // Show open source licenses
                      showLicensePage(context: context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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