

// lib/presentation/pages/auth/security_setup_page.dart

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
import '../../widgets/biometric_prompt.dart';

class SecuritySetupPage extends StatefulWidget {
  const SecuritySetupPage({Key? key}) : super(key: key);

  @override
  State<SecuritySetupPage> createState() => _SecuritySetupPageState();
}

class _SecuritySetupPageState extends State<SecuritySetupPage> {
  String _pin = '';
  String _confirmPin = '';
  bool _bioEnabled = false;
  bool _isBioSupported = false;

  late List<TextEditingController> _pinControllers;
  late List<FocusNode> _pinFocusNodes;
  late List<TextEditingController> _confirmPinControllers;
  late List<FocusNode> _confirmPinFocusNodes;




  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();

    // Initialize PIN field controllers
    _pinControllers = List.generate(
      AppConstants.pinLength,
          (index) => TextEditingController(),
    );
    _pinFocusNodes = List.generate(
      AppConstants.pinLength,
          (index) => FocusNode(),
    );

    // Initialize Confirm PIN field controllers
    _confirmPinControllers = List.generate(
      AppConstants.pinLength,
          (index) => TextEditingController(),
    );
    _confirmPinFocusNodes = List.generate(
      AppConstants.pinLength,
          (index) => FocusNode(),
    );
  }

  @override
  void dispose() {
    // Dispose PIN controllers
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var node in _pinFocusNodes) {
      node.dispose();
    }

    // Dispose Confirm PIN controllers
    for (var controller in _confirmPinControllers) {
      controller.dispose();
    }
    for (var node in _confirmPinFocusNodes) {
      node.dispose();
    }

    super.dispose();
  }
  void _onPinChanged(String value, int index) {
    // Update the PIN string
    String newPin = '';
    for (int i = 0; i < AppConstants.pinLength; i++) {
      newPin += _pinControllers[i].text;
    }
    setState(() {
      _pin = newPin;
    });

    // Auto-focus to next field
    if (value.isNotEmpty && index < AppConstants.pinLength - 1) {
      FocusScope.of(context).requestFocus(_pinFocusNodes[index + 1]);
    }
  }

  void _onConfirmPinChanged(String value, int index) {
    // Update the Confirm PIN string
    String newConfirmPin = '';
    for (int i = 0; i < AppConstants.pinLength; i++) {
      newConfirmPin += _confirmPinControllers[i].text;
    }
    setState(() {
      _confirmPin = newConfirmPin;
    });

    // Auto-focus to next field
    if (value.isNotEmpty && index < AppConstants.pinLength - 1) {
      FocusScope.of(context).requestFocus(_confirmPinFocusNodes[index + 1]);
    }
  }

  Widget _buildPinField({
    required String label,
    required List<TextEditingController> controllers,
    required List<FocusNode> focusNodes,
    required Function(String, int) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            AppConstants.pinLength,
                (index) => Container(
              width: 50,
              height: 60,
              child: TextFormField(
                controller: controllers[index],
                focusNode: focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                obscureText: true,
                obscuringCharacter: '•',
                style: const TextStyle(fontSize: 20),
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
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                onChanged: (value) => onChanged(value, index),
              ),
            ),
          ),
        ),
      ],
    );
  }




  Future<void> _checkBiometricSupport() async {
    final biometricPrompt = BiometricPrompt();
    final supported = await biometricPrompt.isSupported();
    if (mounted) setState(() => _isBioSupported = supported);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading:GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(

              decoration: BoxDecoration(
                color: Color.fromRGBO(156, 163, 175, 1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios, size: 12, color: Colors.white),
            ),
          ),
        ),

        title: Text(
          'Setup Security',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Secure Your Account',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Set up a PIN for quick access',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),


              _buildPinField(
                label: 'Create 4-Digit PIN',
                controllers: _pinControllers,
                focusNodes: _pinFocusNodes,
                onChanged: _onPinChanged,
              ),

              const SizedBox(height: 32),

              // Confirm PIN Field
              _buildPinField(
                label: 'Confirm PIN',
                controllers: _confirmPinControllers,
                focusNodes: _confirmPinFocusNodes,
                onChanged: _onConfirmPinChanged,
              ),
              const SizedBox(height: 32),

              // Biometric Option (Optional)
              if (_isBioSupported) ...[
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.divider),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.fingerprint, color: AppColors.primary),
                    title: const Text('Enable Biometric'),
                    subtitle: const Text('Use fingerprint or face to login'),
                    trailing: Switch(
                      value: _bioEnabled,
                      onChanged: (value) async {
                        if (value) {
                          final biometricPrompt = BiometricPrompt();
                          final authenticated = await biometricPrompt.authenticate('Enable Biometric Authentication');
                          if (mounted) setState(() => _bioEnabled = authenticated);
                        } else {
                          setState(() => _bioEnabled = false);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Complete Setup Button
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    context.push('/connect-estate');
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
                    return CustomButton(
                      text: 'Complete Setup',
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (_pin.length != AppConstants.pinLength) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter complete PIN'), backgroundColor: AppColors.error),
                          );
                          return;
                        }
                        if (_confirmPin.length != AppConstants.pinLength) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please confirm your PIN'), backgroundColor: AppColors.error),
                          );
                          return;
                        }
                        if (_pin != _confirmPin) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('PINs do not match'), backgroundColor: AppColors.error),
                          );
                          return;
                        }
                        context.read<AuthBloc>().add(SetupSecurityEvent(_pin, _bioEnabled));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}