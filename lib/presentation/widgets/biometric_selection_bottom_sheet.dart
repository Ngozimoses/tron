// lib/presentation/widgets/biometric_selection_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class BiometricSelectionBottomSheet extends StatefulWidget {
  final Function(String biometricType) onSelect;
  final VoidCallback onSkip;

  const BiometricSelectionBottomSheet({
    Key? key,
    required this.onSelect,
    required this.onSkip,
  }) : super(key: key);

  @override
  State<BiometricSelectionBottomSheet> createState() => _BiometricSelectionBottomSheetState();
}

class _BiometricSelectionBottomSheetState extends State<BiometricSelectionBottomSheet>
    with TickerProviderStateMixin {
  String? _selectedBiometric;

  // Animation controllers for entrance animations
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Animation controllers for each option
  late List<AnimationController> _optionControllers;
  late List<Animation<double>> _optionScaleAnimations;
  late List<Animation<double>> _optionFadeAnimations;

  // Animation controller for continue button
  late AnimationController _continueButtonController;
  late Animation<double> _continueButtonScaleAnimation;
  late Animation<double> _continueButtonFadeAnimation;

  // Animation controller for skip button
  late AnimationController _skipButtonController;
  late Animation<double> _skipButtonFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize entrance animation
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Initialize option animations (4 options)
    _optionControllers = List.generate(4, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + (index * 100)), // Staggered durations
      );
    });

    _optionScaleAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _optionControllers[index],
          curve: Curves.elasticOut,
        ),
      );
    });

    _optionFadeAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _optionControllers[index],
          curve: Curves.easeOut,
        ),
      );
    });

    // Initialize continue button animation
    _continueButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _continueButtonScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _continueButtonController,
        curve: Curves.easeOutBack,
      ),
    );

    _continueButtonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _continueButtonController,
        curve: Curves.easeOut,
      ),
    );

    // Initialize skip button animation
    _skipButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _skipButtonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _skipButtonController,
        curve: Curves.easeOut,
      ),
    );

    // Start entrance animations
    _entranceController.forward();

    // Stagger option animations
    for (var i = 0; i < _optionControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 200 + (i * 150)), () {
        if (mounted) {
          _optionControllers[i].forward();
        }
      });
    }

    // Animate continue and skip buttons after options
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _continueButtonController.forward();
        _skipButtonController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    _continueButtonController.dispose();
    _skipButtonController.dispose();
    super.dispose();
  }

  void _onOptionSelected(String value) {
    setState(() {
      _selectedBiometric = value;
    });

    // Add haptic feedback (optional)
    // HapticFeedback.lightImpact();

    // Animate selected option
    final selectedIndex = _getOptionIndex(value);
    if (selectedIndex != -1) {
      _optionControllers[selectedIndex].forward(from: 0.8).then((_) {
        if (mounted) {
          _optionControllers[selectedIndex].forward();
        }
      });
    }

    // Animate continue button when selection is made
    _continueButtonController.forward(from: 0.9);
  }

  int _getOptionIndex(String value) {
    const options = ['face_id', 'fingerprint', 'pin', 'password'];
    return options.indexOf(value);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar with fade animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
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
              ),

              // Title with slide animation
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _entranceController,
                  curve: const Interval(0.1, 0.4, curve: Curves.easeOut),
                )),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Select Authentication Method',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Description with slide animation
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _entranceController,
                  curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
                )),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Choose how you want to secure your account',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Biometric Options Grid with staggered animations
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _buildAnimatedBiometricOption('Face ID', Icons.face_outlined, 'face_id', 0),
                  _buildAnimatedBiometricOption('Fingerprint', Icons.fingerprint, 'fingerprint', 1),
                  _buildAnimatedBiometricOption('PIN', Icons.lock_outline, 'pin', 2),
                  _buildAnimatedBiometricOption('Password', Icons.password, 'password', 3),
                ],
              ),
              const SizedBox(height: 32),

              // Continue Button with animation
              FadeTransition(
                opacity: _continueButtonFadeAnimation,
                child: ScaleTransition(
                  scale: _continueButtonScaleAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedBiometric != null
                          ? () => widget.onSelect(_selectedBiometric!)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: AppColors.divider,
                      ),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Skip Button with animation
              FadeTransition(
                opacity: _skipButtonFadeAnimation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _skipButtonController,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Add a subtle animation before dismissing
                      _skipButtonController.forward(from: 0.9).then((_) {
                        widget.onSkip();
                      });
                    },
                    child: Text(
                      'Not Now, Skip',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBiometricOption(String label, IconData icon, String value, int index) {
    final isSelected = _selectedBiometric == value;

    return AnimatedBuilder(
      animation: _optionControllers[index],
      builder: (context, child) {
        return FadeTransition(
          opacity: _optionFadeAnimations[index],
          child: ScaleTransition(
            scale: _optionScaleAnimations[index],
            child: _buildBiometricOption(label, icon, value, isSelected),
          ),
        );
      },
    );
  }

  Widget _buildBiometricOption(String label, IconData icon, String value, bool isSelected) {
    return GestureDetector(
      onTap: () => _onOptionSelected(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Icon(
                icon,
                size: 40,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),

            // Animated text
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              child: Text(label),
            ),

            // Selection indicator with animation
            if (isSelected)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(top: 4),
                width: 24,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}