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

  // ✅ State variable to toggle between phone and email
  late bool _isEmailMode = false;
 late bool _isChecked = false;

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

  // ✅ Get appropriate label based on mode
  String get _inputLabel => _isEmailMode ? 'Enter Your Email' : 'Enter Your Phone Number';

  // ✅ Get appropriate keyboard type based on mode
  TextInputType get _keyboardType => _isEmailMode ? TextInputType.emailAddress : TextInputType.phone;

  // ✅ Get appropriate validator based on mode
  String? Function(String?)? get _validator => _isEmailMode ? Validators.validateEmail : Validators.validatePhone;

  // ✅ Get appropriate prefix icon based on mode
  Widget get _prefixIcon => Icon(
    _isEmailMode ? Icons.email_outlined : Icons.local_phone_outlined,
    color: AppColors.textSecondary,
  );

  // ✅ Get appropriate helper text based on mode
  String get _helperText => _isEmailMode
      ? 'After inputting your email we\'ll send a 4-digit OTP'
      : 'After inputting your number we\'ll send a 4-digit OTP';

  // ✅ Get toggle button text based on mode
  String get _toggleButtonText => _isEmailMode ? 'Login with Phone' : 'Login with Email';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
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
                              SvgIcons.esate(size: 78),
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
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      _isEmailMode ? "E-mail":'Phone Number',
                      style: GoogleFonts.outfit(
                        fontSize: 16, fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(

                      label: _inputLabel,
                      controller: _contactController,
                      keyboardType: _keyboardType,
                      validator: _validator,
                      prefixIcon: _prefixIcon,
                    ),
                    const SizedBox(height: 14),

                    // ✅ Dynamic Helper Text
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
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                          activeColor: AppColors.primary,
                          checkColor: Colors.white,
                          side: BorderSide(
                            color: AppColors.primaryblack.withOpacity(0.5),
                            width: 1.25,
                          ),
                        ),
                        Expanded(
                          child:   Text(
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

                    BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthOtpSent) {
                          // ✅ Show OTP as bottom sheet instead of navigating
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            useSafeArea: true,
                            builder: (context) => OtpVerificationBottomSheet(
                              contact: _contactController.text.trim(),
                              onVerified: () {
                                // Navigate to security setup after verification
                                context.go('/security-setup');
                              },
                              onClose: () {
                                // Optional: Handle close action
                              },
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
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      SendOtpEvent(_contactController.text.trim()),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 10),

                              // ✅ Toggle Button: Switch between Email/Phone
                              CustomButton(
                                color: Colors.white,
                                textColor: Color.fromRGBO(11, 11, 11, 0.45),
                                 borderWidth: 1.5,
                                borderColor: AppColors.primaryblack.withOpacity(0.2),
                                borderRadius: 12,
                                isLoading: state is AuthLoading,
                                onPressed: _toggleLoginMode, // ✅ Toggle mode on tap
                                text: _toggleButtonText, // ✅ Dynamic text
                              ), ],
                          );
                        },
                      ),
                    ),
                    // Bloc Listener for Auth State
                    const SizedBox(height: 24),

                    // Terms & Conditions
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                          activeColor: AppColors.primary,
                          checkColor: Colors.white,
                          side: BorderSide(
                            color: AppColors.primaryblack.withOpacity(0.5),
                            width: 1.25,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'By continuing, you agree to our security policy and terms of use',
                              style:   GoogleFonts.outfit(
                                fontSize: 12,
                                color: AppColors.primaryblack,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const DevBadge(),  ],
      ),
    );
  }
}