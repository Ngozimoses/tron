// lib/presentation/pages/auth/password_setup_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';

class PasswordSetupPage extends StatefulWidget {
  const PasswordSetupPage({Key? key}) : super(key: key);

  @override
  State<PasswordSetupPage> createState() => _PasswordSetupPageState();
}

class _PasswordSetupPageState extends State<PasswordSetupPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _passwordSlideAnimation;
  late Animation<Offset> _confirmSlideAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _titleSlideAnimation = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    _passwordSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    ));

    _confirmSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.4, 0.75, curve: Curves.easeOut),
    ));

    _buttonSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String label,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.95, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          builder: (context, scale, child) => Transform.scale(
            scale: scale,
            child: child,
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.outfit(
                  color: Color.fromRGBO(156, 163, 175, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 16
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(156, 163, 175, 1),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(156, 163, 175, 1),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(156, 163, 175, 1),
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => RotationTransition(
                  turns: Tween(begin: 0.85, end: 1.0).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: IconButton(
                  key: ValueKey(obscureText),
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textHint,
                  ),
                  onPressed: onToggleVisibility,
                ),
              ),
            ),
            validator: validator,
          ),
        ),
      ],
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
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title slides in from top
                  SlideTransition(
                    position: _titleSlideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Password',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create a strong password to secure your account',
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

                  // Password field slides in from bottom
                  SlideTransition(
                    position: _passwordSlideAnimation,
                    child: _buildPasswordField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      label: 'Password',
                      hint: 'Enter password',
                      onToggleVisibility: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter a password';
                        if (value.length < 8) return 'Password must be at least 8 characters';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Confirm field slides in slightly later
                  SlideTransition(
                    position: _confirmSlideAnimation,
                    child: _buildPasswordField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      label: 'Confirm Password',
                      hint: 'Confirm password',
                      onToggleVisibility: () => setState(
                              () => _obscureConfirmPassword = !_obscureConfirmPassword),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please confirm your password';
                        if (value != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Buttons slide in last
                  SlideTransition(
                    position: _buttonSlideAnimation,
                    child: Column(
                      children: [
                        CustomButton(
                          text: 'Continue',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.push('/connect-estate');
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            builder: (context, value, child) =>
                                Opacity(opacity: value, child: child),
                            child: TextButton(
                              onPressed: () => context.push('/connect-estate'),
                              child: Text(
                                'Skip for now',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                     ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}