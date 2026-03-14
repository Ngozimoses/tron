import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/custom_button.dart';

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
  State<OtpVerificationBottomSheet> createState() =>
      _OtpVerificationBottomSheetState();
}

class _OtpVerificationBottomSheetState
    extends State<OtpVerificationBottomSheet> {
  String _otp = '';
  final _formKey = GlobalKey<FormState>();

  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      AppConstants.otpLength,
          (_) => TextEditingController(),
    );

    _focusNodes = List.generate(
      AppConstants.otpLength,
          (_) => FocusNode(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }

    for (var node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length > 1) {
      _controllers[index].text = value[value.length - 1];
      _controllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: _controllers[index].text.length),
      );
    }

    String newOtp = '';
    for (int i = 0; i < AppConstants.otpLength; i++) {
      newOtp += _controllers[i].text;
    }

    setState(() => _otp = newOtp);

    if (value.isNotEmpty && index < AppConstants.otpLength - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }

    if (newOtp.length == AppConstants.otpLength && !_isVerifying) {
      _verifyOtp();
    }
  }

  void _verifyOtp() {
    if (_isVerifying) return;

    if (_otp.length != AppConstants.otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete OTP'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);

    context.read<AuthBloc>().add(
      VerifyOtpEvent(widget.contact, _otp),
    );
  }

  void _closeSheet() {
    Navigator.pop(context);
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
          children: [
            /// Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            /// Close button
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

            /// Title
            Text(
              'OTP Verification',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Enter the ${AppConstants.otpLength}-digit code sent to:',
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: const Color.fromRGBO(156, 163, 175, 1),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.contact,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 32),

            /// OTP Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                AppConstants.otpLength,
                    (index) => SizedBox(
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) => _onOtpChanged(value, index),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            /// Bloc Listener
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is PasswordSetupRequired) {
                  _isVerifying = false;

                  Navigator.pop(context);

                  widget.onVerified?.call();

                  context.go('/password-setup');
                }

                if (state is AuthError) {
                  _isVerifying = false;

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
                  final isLoading = state is AuthLoading || _isVerifying;

                  return Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          color: Colors.white,
                          textColor: AppColors.primaryblack,
                          borderWidth: 1.5,
                          borderColor:
                          AppColors.primaryblack.withOpacity(0.2),
                          borderRadius: 12,
                          onPressed: _closeSheet,
                          text: "Close",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: 'Verify',
                          isLoading: isLoading,
                          onPressed: _verifyOtp,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            /// Resend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive any code?",
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: const Color.fromRGBO(156, 163, 175, 1),
                  ),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return TextButton(
                      onPressed: (state is AuthLoading || _isVerifying)
                          ? null
                          : () {
                        context
                            .read<AuthBloc>()
                            .add(ResendOtpEvent());
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

            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}