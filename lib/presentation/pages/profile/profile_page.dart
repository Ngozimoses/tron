import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/local/auth_local_datasource.dart';
import '../../router/auth_notifier.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  bool _biometricsEnabled = false;
  bool _isLoggingOut = false;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _profileCardSlide;
  late Animation<Offset> _accountSlide;
  late Animation<Offset> _securitySlide;
  late Animation<Offset> _settingsSlide;
  late Animation<Offset> _logoutSlide;

  @override
  void initState() {
    super.initState();
    _checkBiometricStatus();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _profileCardSlide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    ));

    _accountSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.15, 0.5, curve: Curves.easeOut),
    ));

    _securitySlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.3, 0.65, curve: Curves.easeOut),
    ));

    _settingsSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.45, 0.78, curve: Curves.easeOut),
    ));

    _logoutSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
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

  Future<void> _checkBiometricStatus() async {
    try {
      final localDs = di.sl<AuthLocalDataSource>();
      final isEnabled = await localDs.isBiometricEnabled();
      if (mounted) setState(() => _biometricsEnabled = isEnabled);
    } catch (e) {
      debugPrint('Error checking biometric status: $e');
    }
  }

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    try {
      final localDs = di.sl<AuthLocalDataSource>();
      await localDs.clearAuthData();
      if (mounted) {
        authNotifier.logout();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        context.go('/identify');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: !_isLoggingOut,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: _isLoggingOut ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: _isLoggingOut
                ? null
                : () {
              Navigator.pop(context);
              _logout();
            },
            child: _isLoggingOut
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resident = {
      'name': 'Lawal Rahman',
      'email': 'Lawalabdulrahman@gmail.com',
      'phone': '+234 801 234 5678',
      'block': 'A',
      'unit': '101',
      'avatar': null,
      'isPrimaryResident': true,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(color: Colors.white),
        backgroundColor: Colors.white,
        title: Text(
          'My Profile',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Profile card slides in from top
                  SlideTransition(
                    position: _profileCardSlide,
                    child: _buildProfileCard(resident),
                  ),
                  const SizedBox(height: 24),

                  // Account section
                  SlideTransition(
                    position: _accountSlide,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          icon: Icons.person_pin_outlined,
                          title: 'Account',
                        ),
                        const SizedBox(height: 8),
                        _buildAccountSection(context, resident),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Security section
                  SlideTransition(
                    position: _securitySlide,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          icon: Icons.security,
                          title: 'Security',
                        ),
                        const SizedBox(height: 8),
                        _buildSecuritySection(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Settings section
                  SlideTransition(
                    position: _settingsSlide,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          icon: Icons.settings,
                          title: 'Settings',
                        ),
                        const SizedBox(height: 8),
                        _buildAdditionalSettingsSection(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Logout button slides in last
                  SlideTransition(
                    position: _logoutSlide,
                    child: _buildLogoutButton(context),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Loading overlay fades in/out
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isLoggingOut
                ? Container(
              key: const ValueKey('overlay'),
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> resident) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color.fromRGBO(156, 163, 175, 1),
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
        child: Row(
          children: [
            // Avatar with tap ripple
            GestureDetector(
              onTap: () => context.push('/manage-personal-data'),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: resident['avatar'] != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      resident['avatar'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 32,
                        color: AppColors.textHint,
                      ),
                    ),
                  )
                      : const Icon(
                    Icons.person,
                    size: 32,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resident['name'] ?? 'Resident',
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home_rounded, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          resident['isPrimaryResident'] == true
                              ? 'Primary Resident'
                              : 'Resident',
                          style: GoogleFonts.outfit(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Block ${resident['block']}, Unit ${resident['unit']}',
                    style: GoogleFonts.outfit(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(
      BuildContext context, Map<String, dynamic> resident) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color.fromRGBO(156, 163, 175, 0.2), width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuTile(
            title: 'Account Information',
            onTap: () => context.push('/manage-personal-data'),
          ),
          const SizedBox(height: 4),
          _buildMenuTile(
            title: 'Incident Report',
            onTap: () => context.push('/manage-personal-data'),
          ),
          const SizedBox(height: 4),
          _buildInfoRowWithButton(
            icon: Icons.phone_outlined,
            label: 'Phone:',
            value: resident['phone'] ?? '',
            buttonText: 'Change',
            onButtonPressed: () => context.push('/change-phone'),
          ),
          const SizedBox(height: 12),
          _buildInfoRowWithButton(
            icon: Icons.email_outlined,
            label: 'Email:',
            value: resident['email'] ?? '',
            buttonText: 'Change',
            onButtonPressed: () => context.push('/change-email'),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color.fromRGBO(156, 163, 175, 0.2), width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuTile(
            icon: Icons.people_outline,
            title: 'Manage Sub-Residents',
            onTap: () => context.push('/sub-residents'),
          ),
          const SizedBox(height: 4),

          // Biometrics toggle with animated icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.fingerprint,
                    key: ValueKey(_biometricsEnabled),
                    color: _biometricsEnabled
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Enable / Disable Biometrics',
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),

                Switch(
                  value: _biometricsEnabled,
                  onChanged: (value) {
                    setState(() => _biometricsEnabled = value);
                    if (value) context.push('/change-biometrics');
                  }, activeColor: AppColors.primary,inactiveThumbColor:Color.fromRGBO(0, 0, 0, 1),inactiveTrackColor: Color.fromRGBO(196, 196, 196, 0.7),

                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          _buildButtonRow(
            icon: Icons.fingerprint,
            title: 'Biometrics',
            buttonText: _biometricsEnabled ? 'Change' : 'Setup',
            onPressed: () => context.push('/change-biometrics'),
          ),
          const SizedBox(height: 12),

          _buildMenuTile(
            icon: Icons.security,
            title: 'Two-Step Verification',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Two-step verification settings')),
            ),
          ),
          const SizedBox(height: 12),

          _buildMenuTile(
            icon: Icons.devices,
            title: 'Active Sessions',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Active sessions management')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalSettingsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color.fromRGBO(156, 163, 175, 0.2), width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuTile(
            icon: Icons.privacy_tip,
            title: 'Privacy & Permissions',
            onTap: () => context.push('/privacy-permissions'),
          ),
          const SizedBox(height: 4),
          _buildMenuTile(
            icon: Icons.notifications,
            title: 'Notification Settings',
            onTap: () => context.push('/notification-settings'),
          ),
          const SizedBox(height: 4),
          _buildMenuTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () => context.push('/help-support'),
          ),
          const SizedBox(height: 4),
          _buildMenuTile(
            icon: Icons.info_outline,
            title: 'About the Estate App',
            onTap: () => context.push('/about-app'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _isLoggingOut ? null : _showLogoutDialog,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isLoggingOut
                ? const SizedBox(
              key: ValueKey('loading'),
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.error),
              ),
            )
                : const Icon(
              key: ValueKey('icon'),
              Icons.logout,
              color: AppColors.error,
            ),
          ),
          label: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              key: ValueKey(_isLoggingOut),
              _isLoggingOut ? 'Logging out...' : 'Logout',
              style: GoogleFonts.outfit(color: AppColors.error),
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.error),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
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

  Widget _buildInfoRowWithButton({
    required IconData icon,
    required String label,
    required String value,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.outfit(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onButtonPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow({
    required IconData icon,
    required String title,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                  color: AppColors.textPrimary, fontSize: 14),
            ),
          ),
          GestureDetector(
            onTap: onPressed,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Container(
                key: ValueKey(buttonText),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  buttonText,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
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

// ═══════════════════════════════════════════════════════
// Search Delegate for Profile Search
// ═══════════════════════════════════════════════════════
class ProfileSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context, query);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context, query);

  Widget _buildSearchResults(BuildContext context, String query) {
    final results = [
      {'title': 'Account Information', 'route': '/manage-personal-data'},
      {'title': 'Change Phone', 'route': '/change-phone'},
      {'title': 'Change Email', 'route': '/change-email'},
      {'title': 'Biometrics', 'route': '/change-biometrics'},
      {'title': 'Privacy & Permissions', 'route': '/privacy-permissions'},
    ]
        .where((item) =>
        item['title'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No results found for "$query"',
          style: GoogleFonts.outfit(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          title: Text(item['title'] as String),
          trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
          onTap: () {
            close(context, null);
            context.push(item['route'] as String);
          },
        );
      },
    );
  }
}