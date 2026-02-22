import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/auth/complete_profile_page.dart';
import '../pages/auth/connect_estate_page.dart';
import '../pages/auth/password_setup_page.dart';
import '../pages/splash/splash_page.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../pages/auth/identify_page.dart';
import '../pages/auth/otp_verification_page.dart';
import '../pages/auth/security_setup_page.dart';
import '../pages/home/home_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/settings/settings_page.dart';
// ✅ Import marketplace pages
import '../pages/marketplace/marketplace_page.dart';
import '../pages/marketplace/search_results_page.dart';
import '../pages/marketplace/service_listing_page.dart';
import '../pages/marketplace/service_detail_page.dart';
import '../widgets/bottom_nav_wrapper.dart';
// Settings imports
import '../pages/settings/change_email_page.dart';
import '../pages/settings/change_phone_page.dart';
import '../pages/settings/change_biometrics_page.dart';
import '../pages/settings/verify_email_otp_page.dart';
import '../pages/settings/verify_phone_otp_page.dart';
import '../pages/settings/privacy_permissions_page.dart';
import '../pages/settings/notification_settings_page.dart';
import '../pages/settings/help_support_page.dart';
import '../pages/settings/about_app_page.dart';
import '../pages/settings/contact_page.dart';
import '../pages/settings/about_qrcl_page.dart';
import '../pages/settings/terms_conditions_page.dart';
import '../pages/settings/privacy_policy_page.dart';
import '../pages/settings/manage_personal_data_page.dart';
import '../pages/settings/terms_of_use_page.dart';
import '../pages/settings/edit_sub_resident_page.dart';
import '../pages/settings/payment_history_page.dart';
// ✅ Visitor QR imports
import '../pages/visitor/visitor_qr_history_page.dart';
import '../pages/visitor/visitor_qr_view_page.dart';

// ═══════════════════════════════════════════════════════
// Shell Route for Pages WITH Bottom Navigation
// ═══════════════════════════════════════════════════════
final _shellRoute = ShellRoute(
  builder: (context, state, child) {
    int selectedIndex = _getSelectedTabIndex(state.uri.path);
    return BottomNavWrapper(
      initialIndex: selectedIndex,
      child: child,
    );
  },
  routes: [
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => const NoTransitionPage(child: HomePage()),
    ),

    // Profile Tab
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => const NoTransitionPage(child: ProfilePage()),
    ),

    // Marketplace Tab + Sub-routes
    GoRoute(
      path: '/marketplace',
      pageBuilder: (context, state) => const NoTransitionPage(child: MarketplacePage()),
      routes: [
        GoRoute(
          path: 'search',
          pageBuilder: (context, state) {
            final query = state.uri.queryParameters['query'] ?? '';
            return NoTransitionPage(child: SearchResultsPage(query: query));
          },
        ),
        GoRoute(
          path: 'service/:serviceId',
          pageBuilder: (context, state) {
            final serviceId = state.pathParameters['serviceId']!;
            return NoTransitionPage(child: ServiceListingPage(query: serviceId));
          },
          routes: [
            GoRoute(
              path: 'details',
              pageBuilder: (context, state) {
                final serviceId = state.pathParameters['serviceId']!;
                return NoTransitionPage(child: ServiceDetailPage(serviceId: serviceId));
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/visitor-qr-history',
      pageBuilder: (context, state) => const NoTransitionPage(child: VisitorQRHistoryPage()),
    ),
    GoRoute(
      path: '/visitor-qr/:id',
      pageBuilder: (context, state) {
        final visitorId = state.pathParameters['id']!;
        return NoTransitionPage(child: VisitorQRViewPage(visitorId: visitorId));
      },
    ),

    // Settings Tab + Sub-routes
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => const NoTransitionPage(child: SettingsPage()),
      routes: [
        GoRoute(path: 'manage-personal-data', pageBuilder: (context, state) => const NoTransitionPage(child: ManagePersonalDataPage())),
        GoRoute(path: 'terms-of-use', pageBuilder: (context, state) => const NoTransitionPage(child: TermsOfUsePage())),
        GoRoute(
          path: 'edit-sub-resident/:id',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: EditSubResidentPage(subResidentId: id));
          },
        ),
        GoRoute(path: 'payment-history', pageBuilder: (context, state) => const NoTransitionPage(child: PaymentHistoryPage())),
        GoRoute(path: 'about-app', pageBuilder: (context, state) => const NoTransitionPage(child: AboutAppPage())),
        GoRoute(path: 'contact', pageBuilder: (context, state) => const NoTransitionPage(child: ContactPage())),
        GoRoute(path: 'about-qrcl', pageBuilder: (context, state) => const NoTransitionPage(child: AboutQRCLPage())),
        GoRoute(path: 'terms-conditions', pageBuilder: (context, state) => const NoTransitionPage(child: TermsConditionsPage())),
        GoRoute(path: 'privacy-policy', pageBuilder: (context, state) => const NoTransitionPage(child: PrivacyPolicyPage())),
        GoRoute(path: 'change-email', pageBuilder: (context, state) => const NoTransitionPage(child: ChangeEmailPage())),
        GoRoute(path: 'change-phone', pageBuilder: (context, state) => const NoTransitionPage(child: ChangePhonePage())),
        GoRoute(
          path: 'verify-phone-otp',
          pageBuilder: (context, state) {
            final phone = state.uri.queryParameters['phone'] ?? '';
            return NoTransitionPage(child: VerifyPhoneOtpPage(phoneNumber: phone));
          },
        ),

        GoRoute(path: 'change-biometrics', pageBuilder: (context, state) => const NoTransitionPage(child: ChangeBiometricsPage())),
        GoRoute(path: 'verify-email-otp', pageBuilder: (context, state) => const NoTransitionPage(child: VerifyEmailOtpPage())),
        GoRoute(path: 'privacy-permissions', pageBuilder: (context, state) => const NoTransitionPage(child: PrivacyPermissionsPage())),
        GoRoute(path: 'notification-settings', pageBuilder: (context, state) => const NoTransitionPage(child: NotificationSettingsPage())),
        GoRoute(path: 'help-support', pageBuilder: (context, state) => const NoTransitionPage(child: HelpSupportPage())),
      ],
    ),
  ],
);





final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: true,

  redirect: (context, state) {
    final isLoggedIn = _checkIfLoggedIn();
    if (isLoggedIn && _isAuthPage(state.uri.path)) return '/home';
    if (!isLoggedIn && _isProtectedPage(state.uri.path)) return '/identify';
    if (state.uri.path == '/' || state.uri.path.isEmpty) {
      return isLoggedIn ? '/home' : '/splash';
    }
    return null;
  },

  routes: [
    // ═══════════════════════════════════════════════════
    // Auth Pages (NO Bottom Navigation)
    // ═══════════════════════════════════════════════════
    GoRoute(path: '/splash', pageBuilder: (context, state) => const NoTransitionPage(child: SplashPage())),
    GoRoute(path: '/onboarding', pageBuilder: (context, state) => const NoTransitionPage(child: OnboardingPage())),
    GoRoute(path: '/identify', pageBuilder: (context, state) => const NoTransitionPage(child: IdentifyPage())),
    GoRoute(path: '/security-setup', pageBuilder: (context, state) => const NoTransitionPage(child: SecuritySetupPage())),
    GoRoute(
      path: '/password-setup',
      pageBuilder: (context, state) => const NoTransitionPage(child: PasswordSetupPage()),
    ),
    GoRoute(
      path: '/connect-estate',
      pageBuilder: (context, state) => const NoTransitionPage(child: ConnectEstatePage()),
    ),
    GoRoute(
      path: '/complete-profile',
      pageBuilder: (context, state) => const NoTransitionPage(child: CompleteProfilePage()),
    ),

    _shellRoute,
  ],
);


int _getSelectedTabIndex(String path) {
  if (path == '/profile' || path.startsWith('/profile/')) return 1;
  if (path == '/settings' || path.startsWith('/settings/')) return 2;
  if (path == '/marketplace' || path.startsWith('/marketplace/')) return 3;
  return 0; // Default: Home
}

bool _checkIfLoggedIn() {
  // ✅ Replace with your actual auth check
  // Example: return AuthSession().isLoggedIn();
  return true; // Mock: always logged in for testing
}

bool _isAuthPage(String path) {
  return path == '/splash' ||
      path == '/onboarding' ||
      path == '/identify' ||
      path == '/security-setup' ||
      path == '/password-setup' ||
      path == '/connect-estate' ||
      path == '/complete-profile';
  // Note: OTP verification is a bottom sheet, not a page
  // Note: Enable Biometric is a bottom sheet, not a page
  // Note: Biometric Selection is a bottom sheet, not a page
  // Note: Face ID/Fingerprint are native prompts, not pages
}

/// Check if path is a protected page (requires authentication)
bool _isProtectedPage(String path) {
  return path == '/home' ||
      path == '/profile' ||
      path.startsWith('/profile/') ||
      path.startsWith('/settings') ||
      path == '/marketplace' ||
      path.startsWith('/marketplace/') ||
      path == '/visitor-qr-history' ||
      path.startsWith('/visitor-qr/');
}