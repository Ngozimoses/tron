// lib/presentation/pages/settings_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/svg_icons.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _searchSlideAnimation;
  late Animation<Offset> _generalSlideAnimation;
  late Animation<Offset> _securitySlideAnimation;
  late Animation<Offset> _paymentsSlideAnimation;

  bool _biometricsEnabled = false;
  bool _twoStepEnabled = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _searchSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    ));

    _generalSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.15, 0.5, curve: Curves.easeOut),
    ));

    _securitySlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.35, 0.7, curve: Curves.easeOut),
    ));

    _paymentsSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.55, 0.9, curve: Curves.easeOut),
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(color: Colors.white),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Settings',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search bar slides in from top
              SlideTransition(
                position: _searchSlideAnimation,
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 24),

              // General section
              SlideTransition(
                position: _generalSlideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('General'),
                    const SizedBox(height: 8),
                    _buildSettingsCard([
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: 'About the Estate App',
                        onTap: () => context.push('/about-app'),
                      ),
                      _buildMenuItem(
                        icon: Icons.report_problem_outlined,
                        title: 'Report an Issue',
                        onTap: () => context.push('/report-issue'),
                      ),
                      _buildMenuItem(
                        icon: Icons.payment_outlined,
                        title: 'Service Charge Payment',
                        onTap: () => context.push('/service-charge-payment'),
                      ),
                      _buildMenuItem(
                        icon: Icons.contact_mail,
                        title: 'Contact',
                        onTap: () => context.push('/contact'),
                      ),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () => context.push('/help-support'),
                      ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Security section
              SlideTransition(
                position: _securitySlideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Security'),
                    const SizedBox(height: 8),
                    _buildSettingsCard([
                      _buildToggleItem(
                        icon: Icons.fingerprint,
                        title: 'Enable / Disable Biometrics',
                        value: _biometricsEnabled,
                        onChanged: (value) =>
                            setState(() => _biometricsEnabled = value),
                      ),
                      _buildButtonItem(
                        icon: Icons.fingerprint,
                        title: 'Biometrics',
                        buttonText: 'Change',
                        onTap: () => context.push('/biometrics-settings'),
                      ),
                      _buildToggleItem(
                        icon: Icons.security,
                        title: 'Two-Step Verification',
                        value: _twoStepEnabled,
                        onChanged: (value) =>
                            setState(() => _twoStepEnabled = value),
                      ),
                      _buildMenuItem(
                        icon: Icons.devices,
                        title: 'Active Sessions',
                        onTap: () => context.push('/active-sessions'),
                      ),
                      _buildMenuItem(
                        icon: Icons.privacy_tip,
                        title: 'Privacy & Permissions',
                        onTap: () => context.push('/privacy-permissions'),
                      ),
                      _buildMenuItem(
                        icon: Icons.notifications,
                        title: 'Notification Settings',
                        onTap: () => context.push('/notification-settings'),
                      ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payments section
              SlideTransition(
                position: _paymentsSlideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Payments & Compliance'),
                    const SizedBox(height: 8),
                    _buildSettingsCard([
                      _buildMenuItem(
                        icon: Icons.receipt_long,
                        title: 'Service Charge Status',
                        onTap: () => context.push('/service-charge-status'),
                      ),
                      _buildMenuItem(
                        icon: Icons.credit_card,
                        title: 'Pay Service Charge',
                        onTap: () => context.push('/pay-service-charge'),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon:      Padding(
          padding: const EdgeInsets.all(11),
          child: SvgIcons.search(size: 24),
        ),
        hintStyle: GoogleFonts.outfit(
          color: const Color.fromRGBO(156, 163, 175, 1),
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromRGBO(156, 163, 175, 1),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromRGBO(156, 163, 175, 1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
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
        color: const Color.fromRGBO(250, 250, 250, 1),
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
            child:SvgIcons.general(size: 24),
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
      child: Column(children: children),
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
            if (icon != null) ...[
              Icon(icon, color: AppColors.primaryblack, size: 24),
              const SizedBox(width: 12),
            ],
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
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          // Icon animates color when toggle changes
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              icon,
              key: ValueKey(value),
              color: value ? AppColors.primary : AppColors.primaryblack,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,inactiveThumbColor:Color.fromRGBO(0, 0, 0, 1),inactiveTrackColor: Color.fromRGBO(196, 196, 196, 0.7),
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
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryblack, size: 24),
          const SizedBox(width: 12),
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
          GestureDetector(
            onTap: onTap,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.95, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
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
          ),
        ],
      ),
    );
  }
}