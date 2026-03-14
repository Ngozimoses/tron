import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/auth/complete_kyc_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/marketplace/add_listing_page.dart';
import '../pages/marketplace/edit_listing_page.dart';
import '../pages/marketplace/my_listings_page.dart';
import '../pages/notifications/notifications_page.dart';
import '../pages/profile/add_sub_resident_page.dart';
import '../pages/profile/sub_residents_page.dart';
import '../pages/visitor/event_qr_code_page.dart';
import '../pages/visitor/events_qrode_history.dart';
import '../pages/visitor/visitor_qr_code_page.dart';
import 'auth_notifier.dart';
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
import '../pages/marketplace/marketplace_page.dart';
import '../pages/marketplace/search_results_page.dart';
import '../pages/marketplace/service_listing_page.dart';
import '../pages/marketplace/service_detail_page.dart';
import '../widgets/bottom_nav_wrapper.dart';
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
import '../pages/visitor/visitor_qr_history_page.dart';
import '../pages/visitor/visitor_qr_view_page.dart';

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
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => const NoTransitionPage(child: ProfilePage()),
    ),
    GoRoute(
      path: '/marketplace/my-listings',
      pageBuilder: (context, state) => const NoTransitionPage(child: MyListingsPage()),
    ),
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
      ],
    ),
  ],
);

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: true,
  refreshListenable: authNotifier,
  redirect: (context, state) {
    final isLoggedIn = authNotifier.isLoggedIn;
    final currentPath = state.uri.path;

    // Splash / initial route handling
    if (currentPath == '/' || currentPath.isEmpty) {
      if (!isLoggedIn) return '/splash';

      // Logged in → go to home
      return '/home';
    }

    // User NOT logged in
    if (!isLoggedIn) {
      if (_isAuthPage(currentPath)) return null;
      return '/identify';
    }

    // User logged in but KYC NOT completed
    if (!authNotifier.hasCompletedKyc) {
      if (currentPath == '/complete-kyc') return null;

      // allow home so user sees banner if needed
      if (currentPath == '/home') return null;

      if (_isProtectedPage(currentPath)) {
        return '/complete-kyc';
      }
    }

    // Logged in and allowed
    if (isLoggedIn) {
      // prevent returning to auth pages
      if (_isAuthPage(currentPath) && currentPath != '/splash') {
        return '/home';
      }

      return null;
    }

    return null;
  },

  routes: [
    // ✅ Auth routes (defined first for priority)
    GoRoute(path: '/login', pageBuilder: (context, state) => const NoTransitionPage(child: LoginPage())),
    GoRoute(path: '/password-setup', pageBuilder: (context, state) => const NoTransitionPage(child: PasswordSetupPage())),
    GoRoute(path: '/complete-kyc', pageBuilder: (context, state) => const NoTransitionPage(child: CompleteKycPage())),

    // ✅ Core auth flow
    GoRoute(path: '/splash', pageBuilder: (context, state) => const NoTransitionPage(child: SplashPage())),
    GoRoute(path: '/onboarding', pageBuilder: (context, state) => const NoTransitionPage(child: OnboardingPage())),
    GoRoute(path: '/identify', pageBuilder: (context, state) => const NoTransitionPage(child: IdentifyPage())),
    GoRoute(path: '/security-setup', pageBuilder: (context, state) => const NoTransitionPage(child: SecuritySetupPage())),
    GoRoute(path: '/connect-estate', pageBuilder: (context, state) => const NoTransitionPage(child: ConnectEstatePage())),
    GoRoute(path: '/complete-profile', pageBuilder: (context, state) => const NoTransitionPage(child: CompleteProfilePage())),
    GoRoute(path: '/pin-entry', pageBuilder: (context, state) => const NoTransitionPage(child: SecuritySetupPage())),

    // ✅ Legal & Info pages
    GoRoute(path: '/about-app', pageBuilder: (context, state) => const NoTransitionPage(child: AboutAppPage())),
    GoRoute(path: '/contact', pageBuilder: (context, state) => const NoTransitionPage(child: ContactPage())),
    GoRoute(path: '/about-qrcl', pageBuilder: (context, state) => const NoTransitionPage(child: AboutQRCLPage())),
    GoRoute(path: '/terms-conditions', pageBuilder: (context, state) => const NoTransitionPage(child: TermsConditionsPage())),
    GoRoute(path: '/privacy-policy', pageBuilder: (context, state) => const NoTransitionPage(child: PrivacyPolicyPage())),

    // ✅ Settings sub-routes
    GoRoute(path: '/change-email', pageBuilder: (context, state) => const NoTransitionPage(child: ChangeEmailPage())),
    GoRoute(path: '/change-phone', pageBuilder: (context, state) => const NoTransitionPage(child: ChangePhonePage())),
    GoRoute(
      path: '/verify-phone-otp',
      pageBuilder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        return NoTransitionPage(child: VerifyPhoneOtpPage(phoneNumber: phone));
      },
    ),
    GoRoute(path: '/change-biometrics', pageBuilder: (context, state) => const NoTransitionPage(child: ChangeBiometricsPage())),
    GoRoute(path: '/verify-email-otp', pageBuilder: (context, state) => const NoTransitionPage(child: VerifyEmailOtpPage())),
    GoRoute(path: '/privacy-permissions', pageBuilder: (context, state) => const NoTransitionPage(child: PrivacyPermissionsPage())),
    GoRoute(path: '/notification-settings', pageBuilder: (context, state) => const NoTransitionPage(child: NotificationSettingsPage())),
    GoRoute(path: '/help-support', pageBuilder: (context, state) => const NoTransitionPage(child: HelpSupportPage())),

    // ✅ Visitor QR routes
    GoRoute(path: '/visitor-qr-history', pageBuilder: (context, state) => const NoTransitionPage(child: VisitorQRHistoryPage())),
    GoRoute(path: '/event-qr-history', pageBuilder: (context, state) => const NoTransitionPage(child: EventsPage())),
    GoRoute(
      path: '/visitor-qr/:id',
      pageBuilder: (context, state) {
        final visitorId = state.pathParameters['id']!;
        return NoTransitionPage(child: VisitorQRViewPage(visitorId: visitorId));
      },
    ),

    // ✅ Sub-resident routes
    GoRoute(path: '/sub-residents', pageBuilder: (context, state) => const NoTransitionPage(child: SubResidentsPage())),
    GoRoute(path: '/add-sub-resident', pageBuilder: (context, state) => const NoTransitionPage(child: AddSubResidentPage())),
    GoRoute(
      path: '/edit-sub-resident/:id',
      pageBuilder: (context, state) {
        final subResident = state.extra as Map<String, dynamic>;
        return NoTransitionPage(child: EditSubResidentPage(subResidentId: subResident['id']));
      },
    ),

    // ✅ QR Code display routes
    GoRoute(
      path: '/visitor-qr-code',
      pageBuilder: (context, state) {
        final visitorData = state.extra as Map<String, dynamic>;
        return NoTransitionPage(child: VisitorQRCodePage(visitorData: visitorData));
      },
    ),
    GoRoute(
      path: '/event-qr-code',
      pageBuilder: (context, state) {
        final eventData = state.extra as Map<String, dynamic>;
        return NoTransitionPage(child: EventQRCodePage(eventData: eventData));
      },
    ),

    // ✅ Notifications
    GoRoute(path: '/notifications', pageBuilder: (context, state) => const NoTransitionPage(child: NotificationsPage())),

    // ✅ Marketplace additional routes
    GoRoute(path: '/marketplace/add-listing', pageBuilder: (context, state) => const NoTransitionPage(child: AddListingPage())),
    GoRoute(
      path: '/marketplace/edit-listing',
      pageBuilder: (context, state) {
        final listing = state.extra as Map<String, dynamic>;
        return NoTransitionPage(child: EditListingPage(listing: listing));
      },
    ),

    // ✅ Shell route for bottom navigation
    _shellRoute,
  ],
);

int _getSelectedTabIndex(String path) {
  if (path == '/profile' || path.startsWith('/profile/')) return 1;
  if (path == '/settings' || path.startsWith('/settings/')) return 2;
  if (path == '/marketplace' || path.startsWith('/marketplace/')) return 3;
  return 0;
}

bool _isAuthPage(String path) {
  return path == '/splash' ||
      path == '/onboarding' ||
      path == '/identify' ||
      path == '/login' ||
      path == '/terms-conditions' ||
      path == '/security-setup' ||
      path == '/password-setup' ||
      path == '/complete-kyc' ||
      path == '/pin-entry';
}

bool _isProtectedPage(String path) {
  return path == '/home' ||
      path == '/profile' ||
      path.startsWith('/profile/') ||
      path.startsWith('/settings') ||
      path == '/privacy-permissions' ||
      path == '/notification-settings' ||
      path == '/help-support' ||
      path == '/change-email' ||
      path == '/change-phone' ||
      path == '/marketplace' ||
      path == '/terms-conditions' ||
      path == '/marketplace/my-listings' ||
      path == '/marketplace/add-listing' ||
      path == '/marketplace/edit-listing' ||
      path.startsWith('/marketplace/search') ||
      path.startsWith('/marketplace/service/') ||
      path == '/visitor-qr-history' ||
      path.startsWith('/visitor-qr/') ||
      path == '/event-qr-history' ||
      path.startsWith('/event-qr/') ||
      path == '/visitor-qr-code' ||
      path == '/event-qr-code' ||
      path == '/notifications' ||
      path == '/sub-residents' ||
      path == '/add-sub-resident' ||
      path == '/edit-sub-resident/:id' ||
      path == '/about-app' ||
      path == '/about-qrcl' ||
      path == '/privacy-policy' ||
      path == '/contact' ||
      path == '/change-biometrics';
}