import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _biometricsEnabled = false;

  @override
  Widget build(BuildContext context) {
    // Mock resident data (replace with BLoC state in production)
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
      appBar: AppBar( backgroundColor:Colors.white,
        title:   Text(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            // _buildSearchBar(),
            const SizedBox(height: 16),

            // Profile Card
            _buildProfileCard(resident),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 1),
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
                    child: const Icon(
                      Icons.person_pin_outlined,
                      size: 24,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Account',
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildAccountSection(context, resident),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 1),
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
                    child: const Icon(
                      Icons.security,
                      size: 24,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
        Text(
          'Security',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),)
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildSecuritySection(context),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 1),
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
                    child: const Icon(
                      Icons.settings,
                      size: 24,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Settings',
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),)
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildAdditionalSettingsSection(context),
            const SizedBox(height: 24),

            // Logout Button
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Search Bar
  // ═══════════════════════════════════════════════════════

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        // Show search modal or navigate to search page
        showSearch(context: context, delegate: ProfileSearchDelegate());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child:   Row(
          children: [
            Icon(
              Icons.search,
              color: AppColors.textHint,
            ),
            SizedBox(width: 8),
            Text(
              'Search',
              style: GoogleFonts.outfit(
                color: AppColors.textHint,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Profile Card
  // ═══════════════════════════════════════════════════════

  Widget _buildProfileCard(Map<String, dynamic> resident) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromRGBO(156, 163, 175, 1),width: 0.4),
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
          // Avatar
          GestureDetector(
            onTap: () => context.push('/settings/manage-personal-data'),
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
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 32,
                      color: AppColors.textHint,
                    );
                  },
                ),
              )
                  : const Icon(
                Icons.person,
                size: 32,
                color: AppColors.textHint,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resident['name'] ?? 'Resident',
                  style:   GoogleFonts.outfit(
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
                      Icon(
                        Icons.home_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        resident['isPrimaryResident'] == true
                            ? 'Primary Resident'
                            : 'Resident',
                        style:   GoogleFonts.outfit(
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
                  style:   GoogleFonts.outfit(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, Map<String, dynamic> resident) {
    return Container(padding: EdgeInsets.all(5),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header

          _buildMenuTile(

            title: 'Account Information',
            onTap: () => context.push('/settings/manage-personal-data'),
          ),

          const SizedBox(height: 4),
          _buildMenuTile(
            title: 'Incident Report',
            onTap: () => context.push('/settings/manage-personal-data'),
          ),

          const SizedBox(height: 4),

          // Phone
          _buildInfoRowWithButton(
            icon: Icons.phone_outlined,
            label: 'Phone:',
            value: resident['phone'] ?? '',
            buttonText: 'Change',
            onButtonPressed: () => context.push('/profile/change-phone'),
          ),

          const SizedBox(height: 12),

          // Email
          _buildInfoRowWithButton(
            icon: Icons.email_outlined,
            label: 'Email:',
            value: resident['email'] ?? '',
            buttonText: 'Change',
            onButtonPressed: () => context.push('/settings/change-email'),
          ),
        ],
      ),
    );
  }


  Widget _buildSecuritySection(BuildContext context) {
    return Container(padding: EdgeInsets.all(5),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header

          // Manage Sub-Residents
          _buildMenuTile(
            icon: Icons.people_outline,
            title: 'Manage Sub-Residents',
            onTap: () {
              // Navigate to sub-residents management
              // For now, show a placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sub-residents management coming soon')),
              );
            },
          ),

          const SizedBox(height: 4),

          // Enable/Disable Biometrics
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.divider),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.fingerprint,
                  color: AppColors.textSecondary,
                  size: 20,
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
                    setState(() {
                      _biometricsEnabled = value;
                    });
                    if (value) {
                      // Navigate to enable biometrics
                      context.push('/settings/change-biometrics');
                    }
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Biometrics
          _buildButtonRow(
            icon: Icons.fingerprint,
            title: 'Biometrics',
            buttonText: _biometricsEnabled ? 'Change' : 'Setup',
            onPressed: () => context.push('/settings/change-biometrics'),
          ),

          const SizedBox(height: 12),

          // Two-Step Verification
          _buildMenuTile(
            icon: Icons.security,
            title: 'Two-Step Verification',
            onTap: () {
              // Navigate to two-step verification settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Two-step verification settings')),
              );
            },
          ),

          const SizedBox(height: 12),

          // Active Sessions
          _buildMenuTile(
            icon: Icons.devices,
            title: 'Active Sessions',
            onTap: () {
              // Navigate to active sessions page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Active sessions management')),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildAdditionalSettingsSection(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          // Privacy & Permissions
          _buildMenuTile(
            icon: Icons.privacy_tip,
            title: 'Privacy & Permissions',
            onTap: () => context.push('/settings/privacy-permissions'),
          ),

          const SizedBox(height: 4),

          // Notification Settings
          _buildMenuTile(
            icon: Icons.notifications,
            title: 'Notification Settings',
            onTap: () => context.push('/settings/notification-settings'),
          ),

          const SizedBox(height: 4),

          // Help & Support
          _buildMenuTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () => context.push('/settings/help-support'),
          ),

          const SizedBox(height: 4),

          // About the App
          _buildMenuTile(
            icon: Icons.info_outline,
            title: 'About the Estate App',
            onTap: () => context.push('/settings/about-app'),
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
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    onPressed: () {
                      // Clear auth session and navigate to login
                      // AuthSession().clear();
                      context.go('/identify');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.logout, color: AppColors.error),
          label:   Text(
            'Logout',
            style: GoogleFonts.outfit(color: AppColors.error),
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
              Icon(
                icon,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style:   GoogleFonts.outfit(
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
                  style:   GoogleFonts.outfit(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GestureDetector(
                  onTap: onButtonPressed,
                  child: Text(
                    buttonText,
                    style:   GoogleFonts.outfit(
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
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style:   GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
              onTap: onPressed,
              child: Text(
                buttonText,
                style:   GoogleFonts.outfit(
                  color: Colors.white,
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

// ═══════════════════════════════════════════════════════
// Search Delegate for Profile Search
// ═══════════════════════════════════════════════════════

class ProfileSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(query);
  }

  Widget _buildSearchResults(String query) {
    // Mock search results
    final results = [
      {'title': 'Account Information', 'route': '/settings/manage-personal-data'},
      {'title': 'Change Phone', 'route': '/profile/change-phone'},
      {'title': 'Change Email', 'route': '/profile/change-email'},
      {'title': 'Biometrics', 'route': '/profile/change-biometrics'},
      {'title': 'Privacy & Permissions', 'route': '/settings/privacy-permissions'},
    ].where((item) =>
        item['title'].toString().toLowerCase().contains(query.toLowerCase())
    ).toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No results found for "$query"',
          style:   GoogleFonts.outfit(color: AppColors.textSecondary),
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
            // Navigate to the selected item
            // context.push(item['route'] as String);
          },
        );
      },
    );
  }
}