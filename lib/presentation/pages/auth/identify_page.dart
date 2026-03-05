import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/dev_badge.dart';
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

  // ✅ State variables
  late bool _isEmailMode = false;
  late bool _keepMeLoggedIn = false;  // Separate state for keep me logged in
  late bool _termsAccepted = false;    // Separate state for terms and conditions

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  // ✅ Toggle between phone and email mode
  void _toggleLoginMode() {
    setState(() {
      _isEmailMode = !_isEmailMode;
      _contactController.clear(); // Clear input when switching
    });
  }

  // ✅ Handle Keep Me Logged In checkbox
  void _onKeepMeLoggedInChanged(bool? value) {
    setState(() {
      _keepMeLoggedIn = value ?? false;
      // Don't automatically check terms when keep me logged in is checked
    });
  }

  // ✅ Handle Terms & Conditions checkbox
  void _onTermsChanged(bool? value) {
    setState(() {
      _termsAccepted = value ?? false;
      // Don't automatically check keep me logged in when terms is checked
    });
  }

  // ✅ Navigate to Terms & Conditions page
  void _navigateToTermsConditions() {
    context.push('/terms-conditions');
  }

  // ✅ Get appropriate label based on mode
  String get _inputLabel => _isEmailMode ? 'Enter Your Email' : 'Enter Your Phone Number';

  // ✅ Get appropriate keyboard type based on mode
  TextInputType get _keyboardType => _isEmailMode ? TextInputType.emailAddress : TextInputType.phone;

  // ✅ Get appropriate validator based on mode
  String? Function(String?)? get _validator => _isEmailMode ? Validators.validateEmail : Validators.validatePhone;

  // ✅ Get appropriate prefix icon based on mode
  Widget get _prefixIcon =>
      _isEmailMode ? SvgIcons.mail01(size: 20,color:  Color.fromRGBO(11, 11, 11, 0.45)): SvgIcons.call02(size: 20,color:  Color.fromRGBO(11, 11, 11, 0.45));

  // ✅ Get appropriate helper text based on mode
  String get _helperText => _isEmailMode
      ? 'After inputting your email we\'ll send a 4-digit OTP'
      : 'After inputting your number we\'ll send a 4-digit OTP';

  // ✅ Get toggle button text based on mode
  String get _toggleButtonText => _isEmailMode ? 'Login with Phone' : 'Login with Email';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(   flexibleSpace: Container(color: Colors.white),
        backgroundColor: Colors.white,
        elevation: 0,
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
                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Logo and Title
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
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

                              // Welcome Text
                              Text(
                                'Welcome',
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Access your estate securely',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color:  Color.fromRGBO(11, 11, 11, 0.45),
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Input Label
                              Text(
                                _isEmailMode ? "E-mail" : 'Phone Number',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Input Field
                              CustomTextField(
                                label: _inputLabel,
                                controller: _contactController,
                                keyboardType: _keyboardType,
                                validator: _validator,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: _prefixIcon,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Dynamic Helper Text
                              Text(
                                _helperText,
                                style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: AppColors.primaryblack,
                                    fontWeight: FontWeight.w400
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 24),

                              // Keep Me Logged In Checkbox
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: _keepMeLoggedIn,  // Use separate state
                                    onChanged: _onKeepMeLoggedInChanged,
                                    activeColor: AppColors.primary,
                                    checkColor: Colors.white,
                                    side: BorderSide(
                                      color: AppColors.primaryblack.withOpacity(0.5),
                                      width: 1.25,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Always keep me logged in',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: AppColors.primaryblack,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Bloc Listener and Buttons
                              BlocListener<AuthBloc, AuthState>(
                                listener: (context, state) {
                                  if (state is AuthOtpSent) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      useSafeArea: true,
                                      builder: (context) => OtpVerificationBottomSheet(
                                        contact: _contactController.text.trim(),
                                        onVerified: () {
                                          context.go('/security-setup');
                                        },
                                        onClose: () {},
                                      ),
                                    );
                                  } else if (state is AuthError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                  }
                                },
                                child: BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    return Column(
                                      children: [
                                        CustomButton(
                                          text: 'Continue',
                                          isLoading: state is AuthLoading,
                                          onPressed: () {
                                            // Check if terms are accepted before proceeding
                                            if (!_termsAccepted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Please accept the terms and conditions to continue'),
                                                  backgroundColor: AppColors.error,
                                                ),
                                              );
                                              return;
                                            }

                                            if (_formKey.currentState!.validate()) {
                                              context.read<AuthBloc>().add(
                                                SendOtpEvent(_contactController.text.trim()),
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 10),

                                        // Toggle Button
                                        CustomButton(
                                          color: Colors.white,
                                          textColor: const Color.fromRGBO(11, 11, 11, 0.45),
                                          borderWidth: 1.5,
                                          borderColor: AppColors.primaryblack.withOpacity(0.2),
                                          borderRadius: 12,
                                          isLoading: state is AuthLoading,
                                          onPressed: _toggleLoginMode,
                                          text: _toggleButtonText,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Terms & Conditions with tappable text
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _termsAccepted,  // Use separate state
                                    onChanged: _onTermsChanged,
                                    activeColor: AppColors.primary,
                                    checkColor: Colors.white,
                                    side: BorderSide(
                                      color: AppColors.primaryblack.withOpacity(0.5),
                                      width: 1.25,
                                    ),
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
                                            TextSpan(
                                              text: 'By continuing, you agree to our ',
                                            ),
                                            TextSpan(
                                              text: 'security policy',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' and ',
                                            ),
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
                              // Add bottom padding for better scrolling
                              const SizedBox(height: 20),
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
          // const DevBadge(),
        ],
      ),
    );
  }
}