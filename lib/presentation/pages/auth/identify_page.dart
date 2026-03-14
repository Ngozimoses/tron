import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/svg_icons.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../core/theme/app_colors.dart';
import 'otp_verification_page.dart';

class IdentifyPage extends StatefulWidget {
  const IdentifyPage({Key? key}) : super(key: key);

  @override
  State<IdentifyPage> createState() => _IdentifyPageState();
}

class _IdentifyPageState extends State<IdentifyPage> {
  final _formKey = GlobalKey<FormState>();
  final _contactController = TextEditingController();
  bool _termsAccepted = false;
  bool _isLoginMode = false; // Toggle between signup/login

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  /// Detect if input is email
  bool _isEmail(String value) => value.contains('@');

  /// Validate email or phone automatically
  String? _validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your email or phone number';
    }
    if (_isEmail(value)) {
      return Validators.validateEmail(value);
    } else {
      return Validators.validatePhone(value);
    }
  }

  /// Navigate to terms
  void _navigateToTermsConditions() {
    context.push('/terms-conditions');
  }

  /// Handle terms checkbox
  void _onTermsChanged(bool? value) {
    setState(() => _termsAccepted = value ?? false);
  }

  /// Toggle between Create Account and Login modes
  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(color: Colors.white),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Logo
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        SvgIcons.estate(size: 78),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Alaska Estate',
                                          style: GoogleFonts.outfit(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.primaryblack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              /// Welcome Text (Dynamic)
                              Text(
                                _isLoginMode ? 'Welcome Back' : 'Welcome',
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isLoginMode
                                    ? 'Login to access your estate'
                                    : 'Access your estate securely',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color.fromRGBO(11, 11, 11, 0.45),
                                ),
                              ),
                              const SizedBox(height: 40),

                              /// Contact Input
                              Text(
                                "Email or Phone Number",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                label: "Enter Email or Phone Number",
                                controller: _contactController,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateContact,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgIcons.mail01(
                                    size: 20,
                                    color: const Color.fromRGBO(11, 11, 11, 0.45),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              /// Helper Text (Dynamic)
                              Text(
                                _isLoginMode
                                    ? "Enter your credentials to login"
                                    : "Enter your email or phone number and we'll send a 4-digit OTP",
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: AppColors.primaryblack,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 32),

                              /// Password Field (Login Mode Only)
                              if (_isLoginMode) ...[
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    return CustomTextField(
                                      label: 'Password',
                                      controller: TextEditingController(), // Use separate controller in real app
                                      isPassword: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      // TODO: Implement forgot password flow
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: GoogleFonts.outfit(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],

                              /// Action Buttons + Bloc Listener
                              BlocListener<AuthBloc, AuthState>(
                                listener: (context, state) {
                                  // ✅ OTP Sent - Show verification bottom sheet
                                  if (state is AuthOtpSent) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      useSafeArea: true,
                                      builder: (context) => OtpVerificationBottomSheet(
                                        contact: _contactController.text.trim(),
                                        onVerified: () {
                                          context.go('/password-setup');
                                        },
                                        onClose: () {},
                                      ),
                                    );
                                  }
                                  // ✅ Login Success - Check KYC status
                                  else if (state is KycRequired) {
                                    context.go('/complete-kyc');
                                  }
                                  else if (state is AuthAuthenticated) {
                                    context.go('/home');
                                  }
                                  // ✅ Error Handling
                                  else if (state is AuthError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                        backgroundColor: AppColors.error,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                                child: BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    final isLoading = state is AuthLoading;

                                    return Column(
                                      children: [
                                        // Primary Action Button
                                        CustomButton(
                                          text: _isLoginMode ? 'Login' : 'Create Account',
                                          isLoading: isLoading,
                                          onPressed: () {
                                            if (!_termsAccepted && !_isLoginMode) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Please accept the terms and conditions'),
                                                  backgroundColor: AppColors.error,
                                                ),
                                              );
                                              return;
                                            }
                                            if (!_formKey.currentState!.validate()) return;

                                            final contact = _contactController.text.trim();

                                            if (_isLoginMode) {
                                              // 🔐 LOGIN FLOW: Email/Phone + Password
                                              // Note: In real app, use separate password controller
                                              context.read<AuthBloc>().add(
                                                LoginEvent(contact, 'temp_password'), // Replace with actual password input
                                              );
                                            } else {
                                              // 📧 SIGNUP FLOW: Send OTP
                                              context.read<AuthBloc>().add(SendOtpEvent(contact));
                                            }
                                          },
                                        ),

                                        const SizedBox(height: 16),

                                        // Secondary Action: Toggle Mode
                                        CustomButton(
                                          text: _isLoginMode ? 'Create New Account' : 'Already have an account? Login',
                                          isLoading: false,
                                          onPressed: _toggleMode,
                                          color: Colors.transparent,
                                          textColor: AppColors.primary,
                                          borderColor: AppColors.primary,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 24),

                              /// Terms & Conditions (Signup Mode Only)
                              if (!_isLoginMode) ...[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: _termsAccepted,
                                      onChanged: _onTermsChanged,
                                      activeColor: AppColors.primary,
                                      checkColor: Colors.white,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: _navigateToTermsConditions,
                                        child: RichText(
                                          text: TextSpan(
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              color: AppColors.primaryblack,
                                              height: 1.4,
                                            ),
                                            children: [
                                              const TextSpan(text: 'By continuing, you agree to our '),
                                              TextSpan(
                                                text: 'security policy',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                              const TextSpan(text: ' and '),
                                              TextSpan(
                                                text: 'terms of use',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
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