// lib/presentation/pages/settings/about_app_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(flexibleSpace: Container(
        color:Colors.white,
      ),
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
        title:   Text(
          'About the App',
          style: GoogleFonts.outfit(
            color: AppColors.primaryblack,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromRGBO(156, 163, 175, 0.2),
                  width: 0.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoRow('App Version', _appVersion.isEmpty ? 'Loading...' : _appVersion),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildInfoRow('Last Updated', _lastUpdated.isEmpty ? 'Loading...' : _lastUpdated),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildMenuItem(
                    title: 'About QRCode.ng',
                    onTap: () => context.push('/about-qrcl'),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildMenuItem(
                    title: 'Terms & Conditions',
                    onTap: () => context.push('/terms-conditions'),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildMenuItem(
                    title: 'Privacy Policy',
                    onTap: () => context.push('/privacy-policy'),
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
            style: GoogleFonts.outfit(
              color: AppColors.primaryblack,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
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
                style: GoogleFonts.outfit(
                  color: AppColors.primaryblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
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