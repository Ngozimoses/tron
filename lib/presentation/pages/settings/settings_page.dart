// lib/presentation/pages/settings/settings_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title:   Text(
          'Settings',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 24),

            // General Section
            _buildSectionHeader('General'),
            const SizedBox(height: 8),
            _buildSettingsCard([
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'About the Estate App',
                onTap: () => context.push('/settings/about-app'),
              ),
              _buildMenuItem(
                icon: Icons.report_problem_outlined,
                title: 'Report an Issue',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.payment_outlined,
                title: 'Service Charge Payment',
                onTap: () {},
              ),
              // In the General section, add:

              _buildMenuItem(
                icon: Icons.contact_mail,
                title: 'Contact',
                onTap: () => context.push('/settings/contact'),
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () => context.push('/settings/help-support'),
              ),
            ]),
            const SizedBox(height: 24),

            // Security Section
            _buildSectionHeader('Security'),
            const SizedBox(height: 8),
            _buildSettingsCard([
              _buildToggleItem(
                icon: Icons.fingerprint,
                title: 'Enable / Disable Biometrics',
                value: false,
                onChanged: (value) {},
              ),
              _buildButtonItem(
                icon: Icons.fingerprint,
                title: 'Biometrics',
                buttonText: 'Change',
                onTap: () => context.push('/settings/change-biometrics'),
              ),
              _buildToggleItem(
                icon: Icons.security,
                title: 'Two-Step Verification',
                value: false,
                onChanged: (value) {},
              ),
              _buildMenuItem(
                icon: Icons.devices,
                title: 'Active Sessions',
                onTap: () {},
              ),_buildMenuItem(
                icon: Icons.privacy_tip,
                title: 'Privacy & Permissions',
                onTap: () => context.push('/settings/privacy-permissions'),
              ),
              _buildMenuItem(
                icon: Icons.notifications,
                title: 'Notification Settings',
                onTap: () => context.push('/settings/notification-settings'),
              ),
            ]),
            const SizedBox(height: 24),

            // Payments & Compliance Section
            _buildSectionHeader('Payments & Compliance'),
            const SizedBox(height: 8),
            _buildSettingsCard([
              _buildMenuItem(
                icon: Icons.receipt_long,
                title: 'Service Charge Status',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.credit_card,
                title: 'Pay Service Charge',
                onTap: () {},
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search_rounded,  color: AppColors.primaryblack,size: 24,),
        hintStyle: GoogleFonts.outfit(color: Color.fromRGBO(156, 163, 175, 1),fontWeight: FontWeight.w400,fontSize: 16),

        // Add border with black color and 12 radius
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromRGBO(156, 163, 175, 1),
            width: 1, // You can adjust the width as needed
          ),
        ),

        // You might also want to define borders for different states
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromRGBO(156, 163, 175, 1),
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromRGBO(156, 163, 175, 1),
            width: 1, // Slightly thicker when focused for better UX
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red, // Keep error border red for visibility
            width: 1,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),

        // Add some content padding for better appearance
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(

      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.settings_outlined,
              size: 18,
              color: AppColors.primaryblack,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryblack,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromRGBO(156, 163, 175, 0.2),width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildMenuItem({
    IconData? icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        child: Row(
          children: [
            if (icon != null) // Only show Icon if icon is not null
              Icon(
                icon,
                color: AppColors.primaryblack,
                size: 24,
              ),
            if (icon != null) const SizedBox(width: 12), // Only add spacing if icon exists
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                    color: AppColors.primaryblack,
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_outlined,
              color: AppColors.primaryblack,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildToggleItem({
    required IconData icon,
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
          Icon(
            icon,
            color: AppColors.primaryblack,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                  color: AppColors.primaryblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
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

  Widget _buildButtonItem({
    required IconData icon,
    required String title,
    required String buttonText,
    required VoidCallback onTap,
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
          Icon(
            icon,
            color: AppColors.primaryblack,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                  color: AppColors.primaryblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}