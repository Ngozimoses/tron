// lib/presentation/widgets/otp_verification_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/biometric_prompt.dart';
import '../../widgets/biometric_selection_bottom_sheet.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/enable_biometric_bottom_sheet.dart';

class OtpVerificationBottomSheet extends StatefulWidget {
  final String contact;
  final VoidCallback? onVerified;
  final VoidCallback? onClose;

  const OtpVerificationBottomSheet({
    Key? key,
    required this.contact,
    this.onVerified,
    this.onClose,
  }) : super(key: key);

  @override
  State<OtpVerificationBottomSheet> createState() => _OtpVerificationBottomSheetState();
}

class _OtpVerificationBottomSheetState extends State<OtpVerificationBottomSheet> {
  String _otp = '';
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      AppConstants.otpLength,
          (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      AppConstants.otpLength,
          (index) => FocusNode(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) controller.dispose();
    for (var node in _focusNodes) node.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    String newOtp = '';
    for (int i = 0; i < AppConstants.otpLength; i++) {
      newOtp += _controllers[i].text;
    }
    setState(() => _otp = newOtp);
    if (value.isNotEmpty && index < AppConstants.otpLength - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
  }

  void _showEnableBiometricSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(
        minHeight: 400, // Minimum height
        maxHeight: 600, // Maximum height
      ),
      isScrollControlled: true,
      builder: (context) => EnableBiometricBottomSheet(
        onEnable: () {
          Navigator.pop(context); // Close enable biometric sheet
          // Show biometric selection
          _showBiometricSelectionSheet(context);
        },
        onSkip: () {
          Navigator.pop(context); // Close enable biometric sheet
          // Skip to Connect Estate
          context.push('/connect-estate');
        },
      ),
    );
  }

  void _showBiometricSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(
        minHeight: 400, // Minimum height
        maxHeight: 600, // Maximum height
      ),
      isScrollControlled: true,
      builder: (context) => BiometricSelectionBottomSheet(
        onSelect: (biometricType) {
          Navigator.pop(context); // Close selection sheet

          // Navigate based on selection
          if (biometricType == 'pin') {
            // Navigate to Security Setup (PIN)
            context.push('/security-setup');
          } else if (biometricType == 'face_id' || biometricType == 'fingerprint') {
            // Setup biometric
            _setupBiometric(biometricType, context);
          } else if (biometricType == 'password') {
            context.push('/password-setup');
          }
        },
        onSkip: () {
          Navigator.pop(context); // Close selection sheet
          // Skip to Connect Estate
          context.push('/connect-estate');
        },
      ),
    );
  }

  Future<void> _setupBiometric(String biometricType, BuildContext context) async {
    final biometricPrompt = BiometricPrompt();
    final success = await biometricPrompt.authenticate(
      'Enable $biometricType for quick access',
    );

    if (success && mounted) {
      // Biometric setup successful
      context.push('/connect-estate');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric setup failed')),
      );
    }
  }
  void _toggleLoginMode() {
    // Close bottom sheet first, then navigate
    Navigator.pop(context);
    // Navigate to change phone page
    // Use GoRouter from context if needed:
    // GoRouter.of(context).push('/settings/change-phone');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Close button (optional)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.textHint),
                onPressed: () {
                  widget.onClose?.call();
                  Navigator.pop(context);
                },
              ),
            ),

            const SizedBox(height: 8),

            // Title
            Text(
              'OTP Verification',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Instruction
            Text(
              'Enter the 4-digit code sent to:',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(156, 163, 175, 1),
              ),
            ),
            const SizedBox(height: 8),

            // Contact
            Text(
              widget.contact,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                AppConstants.otpLength,
                    (index) => Container(
                  width: 50,
                  height: 60,
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    onChanged: (value) => _onOtpChanged(value, index),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Timer
            Text(
              'Code expires in 01:58',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),

            // Buttons Row
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is SecuritySetupRequired) {
                  Navigator.pop(context); // Close OTP bottom sheet

                  // ✅ Show Enable Biometric Bottom Sheet
                  _showEnableBiometricSheet(context);
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
                  return Row(
                    children: [
                      // Change Phone Button
                      Expanded(
                        child: CustomButton(
                          color: Colors.white,
                          textColor: AppColors.primaryblack,
                          borderWidth: 1.5,
                          borderColor: AppColors.primaryblack.withOpacity(0.2),
                          borderRadius: 12,
                          isLoading: false,
                          onPressed: _toggleLoginMode,
                          text: "Close",
                          textsize: 16,
                          textwidth: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Verify Button
                      Expanded(
                        child: CustomButton(
                          textsize: 16,
                          textwidth: FontWeight.w400,
                          textColor: AppColors.textWhite,
                          text: 'Verify',
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            if (_otp.length == AppConstants.otpLength) {
                              context.read<AuthBloc>().add(
                                VerifyOtpEvent(widget.contact, _otp),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter complete OTP'),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Resend Row
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive any code?",
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(156, 163, 175, 1),
                    ),
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return TextButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                          context.read<AuthBloc>().add(ResendOtpEvent());
                        },
                        child: const Text(
                          'Resend',
                          style: TextStyle(
                            color: AppColors.primaryblack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}