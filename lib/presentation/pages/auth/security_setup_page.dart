// lib/presentation/pages/auth/security_setup_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _SecuritySetupPageState extends State<SecuritySetupPage>
    with TickerProviderStateMixin {
  String _pin = '';
  String _confirmPin = '';
  bool _bioEnabled = false;
  bool _isBioSupported = false;

  late List<TextEditingController> _pinControllers;
  late List<FocusNode> _pinFocusNodes;
  late List<TextEditingController> _confirmPinControllers;
  late List<FocusNode> _confirmPinFocusNodes;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _shakeController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _pinSlideAnimation;
  late Animation<Offset> _confirmSlideAnimation;
  late Animation<Offset> _bioSlideAnimation;
  late Animation<Offset> _buttonSlideAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
    _initAnimations();

    _pinControllers = List.generate(AppConstants.pinLength, (_) => TextEditingController());
    _pinFocusNodes = List.generate(AppConstants.pinLength, (_) => FocusNode());
    _confirmPinControllers = List.generate(AppConstants.pinLength, (_) => TextEditingController());
    _confirmPinFocusNodes = List.generate(AppConstants.pinLength, (_) => FocusNode());
  }
  void _onPinChanged(String value, int index) {
    // If more than 1 char somehow entered, trim it
    if (value.length > 1) {
      _pinControllers[index].text = value[0];
      _pinControllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: 1),
      );
    }

    String newPin = '';
    for (int i = 0; i < AppConstants.pinLength; i++) {
      newPin += _pinControllers[i].text;
    }
    setState(() => _pin = newPin);

    if (value.isNotEmpty && index < AppConstants.pinLength - 1) {
      FocusScope.of(context).requestFocus(_pinFocusNodes[index + 1]);
    }
  }

  void _onConfirmPinChanged(String value, int index) {
    if (value.length > 1) {
      _confirmPinControllers[index].text = value[0];
      _confirmPinControllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: 1),
      );
    }

    String newConfirmPin = '';
    for (int i = 0; i < AppConstants.pinLength; i++) {
      newConfirmPin += _confirmPinControllers[i].text;
    }
    setState(() => _confirmPin = newConfirmPin);

    if (value.isNotEmpty && index < AppConstants.pinLength - 1) {
      FocusScope.of(context).requestFocus(_confirmPinFocusNodes[index + 1]);
    }
  }
  void _initAnimations() {
    // Fade + slide in on page load
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    // Shake controller for PIN mismatch error
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _titleSlideAnimation = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)));

    _pinSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: const Interval(0.2, 0.6, curve: Curves.easeOut)));

    _confirmSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: const Interval(0.4, 0.75, curve: Curves.easeOut)));

    _bioSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: const Interval(0.55, 0.85, curve: Curves.easeOut)));

    _buttonSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: const Interval(0.65, 1.0, curve: Curves.easeOut)));

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _triggerShake() async {
    await _shakeController.forward();
    _shakeController.reverse();
  }

  @override
  void dispose() {
    for (var c in _pinControllers) c.dispose();
    for (var n in _pinFocusNodes) n.dispose();
    for (var c in _confirmPinControllers) c.dispose();
    for (var n in _confirmPinFocusNodes) n.dispose();

    _fadeController.dispose();
    _slideController.dispose();
    _shakeController.dispose();

    super.dispose();
  }

  Widget _buildPinField({
    required String label,
    required List<TextEditingController> controllers,
    required List<FocusNode> focusNodes,
    required Function(String, int) onChanged,
    bool shake = false,
  }) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final offset = shake
            ? Offset(8 * (0.5 - _shakeAnimation.value).abs() * (_shakeController.status == AnimationStatus.forward ? 1 : -1), 0)
            : Offset.zero;
        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
      child: Column(
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
                  (index) => TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + index * 80),
                curve: Curves.easeOut,
                builder: (context, value, child) => Transform.scale(
                  scale: value,
                  child: Opacity(opacity: value, child: child),
                ),
                child: SizedBox(
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
                    enableSuggestions: false,
                    autocorrect: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
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
          ),
        ],
      ),
    );
  }

  Future<void> _checkBiometricSupport() async {
    final biometricPrompt = BiometricPrompt();
    final supported = await biometricPrompt.isSupported();
    if (mounted) setState(() => _isBioSupported = supported);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title block slides in from top
                SlideTransition(
                  position: _titleSlideAnimation,
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
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // PIN field slides in from bottom
                SlideTransition(
                  position: _pinSlideAnimation,
                  child: _buildPinField(
                    label: 'Create 4-Digit PIN',
                    controllers: _pinControllers,
                    focusNodes: _pinFocusNodes,
                    onChanged: _onPinChanged,
                  ),
                ),
                const SizedBox(height: 32),

                // Confirm PIN field slides in slightly later
                SlideTransition(
                  position: _confirmSlideAnimation,
                  child: _buildPinField(
                    label: 'Confirm PIN',
                    controllers: _confirmPinControllers,
                    focusNodes: _confirmPinFocusNodes,
                    onChanged: _onConfirmPinChanged,
                    shake: true, // shake applied here on mismatch
                  ),
                ),
                const SizedBox(height: 32),

                // Biometric card animates in
                if (_isBioSupported) ...[
                  SlideTransition(
                    position: _bioSlideAnimation,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Card(
                        key: const ValueKey('bio_card'),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.divider),
                        ),
                        child: ListTile(
                          leading: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.fingerprint,
                              key: ValueKey(_bioEnabled),
                              color: _bioEnabled ? AppColors.primary : Colors.grey,
                              size: 28,
                            ),
                          ),
                          title: const Text('Enable Biometric'),
                          subtitle: const Text('Use fingerprint or face to login'),
                          trailing: Switch(
                            value: _bioEnabled,
                            onChanged: (value) async {
                              if (value) {
                                final biometricPrompt = BiometricPrompt();
                                final authenticated = await biometricPrompt
                                    .authenticate('Enable Biometric Authentication');
                                if (mounted) setState(() => _bioEnabled = authenticated);
                              } else {
                                setState(() => _bioEnabled = false);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Button slides in last
                SlideTransition(
                  position: _buttonSlideAnimation,
                  child: BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthAuthenticated) {
                        context.push('/connect-estate');
                      } else if (state is AuthError) {
                        _showError(state.message);
                      }
                    },
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Complete Setup',
                          isLoading: state is AuthLoading,
                          onPressed: () async {
                            if (_pin.length != AppConstants.pinLength) {
                              _showError('Please enter complete PIN');
                              return;
                            }
                            if (_confirmPin.length != AppConstants.pinLength) {
                              _showError('Please confirm your PIN');
                              return;
                            }
                            if (_pin != _confirmPin) {
                              await _triggerShake();
                              _showError('PINs do not match');
                              return;
                            }
                            context.read<AuthBloc>().add(SetupSecurityEvent(_pin, _bioEnabled));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}